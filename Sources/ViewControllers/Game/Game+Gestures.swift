//
//  Game+Gestures.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 12/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

// MARK: - Gesture Management

extension GameVC {
  func configureGestureRecognizers() {
    panGestureRecognizer.addTarget(self, action: #selector(panGestureDidChange))
    panGestureRecognizer.delegate = self

    paintBall.addGestureRecognizer(panGestureRecognizer)
  }

  @objc private func panGestureDidChange(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      beginInteractiveTransition(with: gesture)
    case .changed:
      updateInteractiveTransition(with: gesture)
    case .ended, .cancelled:
      endInteractiveTransition(with: gesture)
    default:
      break
    }
  }

  public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
    if gesture === panGestureRecognizer {
      // `UIPanGestureRecognizer`s seem to delay their 'began' callback by
      // up to 0.75sec near the edges of the screen. We want to get
      // notified immediately so that we can properly interrupt an ongoing
      // animation.
      DispatchQueue.main.async {
        self.panGestureDidChange(self.panGestureRecognizer)
      }
    }

    return true
  }
}

// MARK: - Interaction Management

extension GameVC {
  /// Get the center position of the pocket in the view coordinatespace
  func centerPoint(pocketIndex: Int) -> CGPoint {
    print("pocketIndex")
    print(pocketIndex)
    print("pocketViewData.count")
    print(pocketViewData.count)
    return pocketViewData[pocketIndex].displayPosition
  }

  /// Initiates a new interactive transition that will be driven by the
  /// specified pan gesture recognizer. If an animation is currently in
  /// progress, it is cancelled on the spot.
  func beginInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    switch state {
    case .idle: break
    case .interaction: return
    case .animating(to: _, using: let animator):
      animator.stopAnimation(true)
    case .initial:
      break
    }

    let startPoint = paintBall.center

    state = .interaction(with: gesture, from: startPoint)

    fingerOnBallHaptic()
    App.shared.game.state.touchingBall()
  }

  /// Updates the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func updateInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: let startPoint) = state else { return }

    let scale = fmax(traitCollection.displayScale, 1)
    let translation = gesture.translation(in: view)

    var center = startPoint + CGVector(to: translation)
    center.x = round(center.x * scale) / scale
    center.y = round(center.y * scale) / scale
    App.shared.game.state.dragging()
    paintBall.center = center
  }

  /// Finishes the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func endInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: _) = state else { return }

    let velocity = CGVector(to: gesture.velocity(in: view))
    if abs(velocity.dx) + abs(velocity.dy) > 250 {
      App.shared.game.state.flickedBall()
    }

    let currentCenter = paintBall.center
    let targetCenter = intendedEndpoint(with: velocity, from: currentCenter)

    guard let targetCenter else { return }

    let targetPocket = endpoint(closestTo: targetCenter)
    let parameters = spring.timingFunction(withInitialVelocity: velocity, from: &paintBall.center, to: targetCenter, context: self)
    let animator = UIViewPropertyAnimator(duration: 0, timingParameters: parameters)

    animator.addAnimations {
      self.paintBall.center = targetCenter
    }

    // MARK: - Ball has come to rest

    animator.addCompletion { _ in
      self.ballInPocketHaptic()
      self.updateGame(targetPocket)
      self.state = .idle(at: targetCenter)
    }

    state = .animating(to: targetCenter, using: animator)

    animator.startAnimation()
    releaseBallHaptic(withVelocity: velocity)
  }

  /// Calculates the endpoint to which the PIP view should move from the
  /// specified current position with the specified velocity.
  func intendedEndpoint(with velocity: CGVector, from currentPosition: CGPoint) -> CGPoint? {
    var velocity = velocity

    // Reduce movement along the secondary axis of the gesture.
    if velocity.dx != 0 || velocity.dy != 0 {
      let velocityInPrimaryDirection = fmax(abs(velocity.dx), abs(velocity.dy))

      velocity.dx *= abs(velocity.dx / velocityInPrimaryDirection)
      velocity.dy *= abs(velocity.dy / velocityInPrimaryDirection)
    }

    let projectedPosition = UIGestureRecognizer.project(velocity, onto: currentPosition)

    let endpoint = self.endpoint(closestTo: projectedPosition)

    return endpoint?.globalCenter
  }

  /// Returns the endpoint closest to the specified point.
  func endpoint(closestTo point: CGPoint) -> PocketView? {
    let viewData = pocketViewData.min { pocket in
      pocket.displayPosition.distance(to: point)
    }
    guard let viewData, let gridCollectionView else { return nil }
    return collectionView(gridCollectionView, cellForItemAt: viewData.id).subviews.first {
      $0.tag == viewData.id.row
    } as? PocketView
  }
}
