//
//  GameVC.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import SpriteKit
import UIKit

typealias GameCallback = (_ level: Level) -> Void

class GameVC: UIViewController, UIGestureRecognizerDelegate {
  // MARK: - Outlets

  @IBOutlet var gridCollectionView: UICollectionView!
  @IBOutlet var levelView: UILabel!
  @IBOutlet var pointsView: UILabel!

  // MARK: - Vars

  private var level: Level { App.shared.game.level }
  private var spring: DampedHarmonicSpring { App.shared.game.level.board.spring }
  private let paintBall: BondiBallView = .init()
  private var pockets: [PocketView] {
    var levelPockets: [PocketView] = .init()
    for _ in 0 ... (App.shared.game.level.board.columns * App.shared.game.level.board.rows) {
      levelPockets.append(PocketView())
    }
    return levelPockets
  }

  private let panGestureRecognizer: UIPanGestureRecognizer = PanGestureRecognizer()
  private let springConfigurationButton: UIButton = .init(style: .alpha)

  var cellWidth: CGFloat { gridCollectionView.frame.width / CGFloat(App.shared.game.level.board.columns) }
  var cellHeight: CGFloat { gridCollectionView.frame.height / CGFloat(App.shared.game.level.board.rows) }
  var pocktetSize: CGFloat { min(cellHeight, cellWidth) * 0.8 }

  // MARK: - Ball state

  /// The current state of the Bondi Ball
  private var state: BondiBallState = .initial

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    subscribe()
  }

  override func viewDidLayoutSubviews() {
    setUpCollectionView()
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
}

// MARK: - Setup UI

extension GameVC {
  private func setupUI() {
    navigationItem.setHidesBackButton(true, animated: true)

    if let game = UINib.game.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(game, pinTo: .layoutMargins)

      pointsView.text = String(App.shared.game.totalPoints)
      levelView.text = String(App.shared.game.level.id)
    }
  }

  private func setUpCollectionView() {
    gridCollectionView
      .register(UICollectionViewCell.self,
                forCellWithReuseIdentifier: "cell")

    gridCollectionView.delegate = self
    gridCollectionView.dataSource = self

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 4

    gridCollectionView
      .setCollectionViewLayout(layout, animated: false)

    setupBall(level: level)
  }

  private func setupBall(level: Level) {
    let startingPocketIndex = level.startPocket.0 * level.startPocket.1 - 1
    let startingPocketCenter = convertToContainerSpace(pocketIndex: startingPocketIndex)

    let ballSize = pocktetSize * 0.8
    paintBall.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)

    paintBall.center = startingPocketCenter
    springConfigurationButton.center = startingPocketCenter

    view.addSubview(paintBall)

    configureGestureRecognizers()
  }
}

// MARK: - Grid laypout

extension GameVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return App.shared.game.level.board.rows
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    let pocket = pockets[indexPath.row]

    pocket.translatesAutoresizingMaskIntoConstraints = false
    pocket.globalCenter = gridCollectionView.convert(cell.center, to: gridCollectionView.superview)

    let containerView = UIView()
    containerView.addSubview(pocket)

    NSLayoutConstraint.activate([
      pocket.heightAnchor.constraint(equalToConstant: pocktetSize),
      pocket.widthAnchor.constraint(equalToConstant: pocktetSize),
      pocket.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      pocket.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ])

    cell.addSubview(containerView, pinTo: .viewEdges)
    print("Pocket Global Center: \(pocket.globalCenter)")
    return cell
  }
}

extension GameVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let lay = collectionViewLayout as! UICollectionViewFlowLayout
    let widthPerItem = collectionView.frame.width / CGFloat(App.shared.game.level.board.columns) - lay.minimumInteritemSpacing
    let heightPerItem = collectionView.frame.height / CGFloat(App.shared.game.level.board.rows) - lay.minimumInteritemSpacing
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
}

// MARK: - Subscribe

extension GameVC {
  func subscribe() {
    App.shared.game.state.subscribe { [weak self] state in
      switch state {
      case .Scored:
        self?.pointsView.text = String(App.shared.game.totalPoints)
      case .LevelingUp:
        self?.levelView.text = String(App.shared.game.level.id)
      case .Playing, .RetryingLevel, .Missed, .Dragging:
        break
      }
    }
  }
}

// MARK: - Game management

extension GameVC {
  func updateGame(_ endpoint: PocketView) {
    if endpoint.isGoal {
      App.shared.game.state.score()
    }
    // If scored
    // If missed
    // If dragging
  }
}

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
  func convertToContainerSpace(pocketIndex: Int) -> CGPoint {
    gridCollectionView.convert(gridCollectionView.layoutAttributesForItem(at: IndexPath(row: pocketIndex, section: 0))!.center, to: view)
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
    paintBall.center = center
  }

  /// Finishes the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func endInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: _) = state else { return }

    let velocity = CGVector(to: gesture.velocity(in: view))
    let currentCenter = paintBall.center
    let endpoint = intendedEndpoint(with: velocity, from: currentCenter)
    let targetCenter = endpoint.center
    let parameters = spring.timingFunction(withInitialVelocity: velocity, from: &paintBall.center, to: targetCenter, context: self)
    let animator = UIViewPropertyAnimator(duration: 0, timingParameters: parameters)

    animator.addAnimations {
      self.paintBall.center = targetCenter
    }

    // MARK: - Ball has come to rest

    animator.addCompletion { _ in
      self.ballInPocketHaptic()
      self.updateGame(endpoint)
      self.state = .idle(at: endpoint)
    }

    state = .animating(to: endpoint, using: animator)

    animator.startAnimation()
    releaseBallHaptic(withVelocity: velocity)
  }

  /// Calculates the endpoint to which the PIP view should move from the
  /// specified current position with the specified velocity.
  private func intendedEndpoint(with velocity: CGVector, from currentPosition: CGPoint) -> PocketView {
    var velocity = velocity

    // Reduce movement along the secondary axis of the gesture.
    if velocity.dx != 0 || velocity.dy != 0 {
      let velocityInPrimaryDirection = fmax(abs(velocity.dx), abs(velocity.dy))

      velocity.dx *= abs(velocity.dx / velocityInPrimaryDirection)
      velocity.dy *= abs(velocity.dy / velocityInPrimaryDirection)
    }

    let projectedPosition = UIGestureRecognizer.project(velocity, onto: currentPosition)

    let endpoint = self.endpoint(closestTo: projectedPosition)

    return endpoint
  }

  /// Returns the endpoint closest to the specified point.
  private func endpoint(closestTo point: CGPoint) -> PocketView {
    let closest = pockets.min(by: { pocket in
      let distance = point.distance(to: pocket.globalCenter)
      print(pocket.globalCenter)
      return distance
    })!
    return closest
  }
}

// - MARK: Haptics
extension GameVC {
  func fingerOnBallHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
  }

  func releaseBallHaptic(withVelocity velocity: CGVector) {
    if velocity.length > 1 {
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred()
    }
  }

  func ballInPocketHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
  }
}
