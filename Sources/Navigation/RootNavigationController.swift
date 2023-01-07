//
//  ViewController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
  // MARK: - Interactions

  private var interactionController: UIPercentDrivenInteractiveTransition?
  private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?

  // MARK: - Visuals

  private let splashScreen: SplashViewController = .init()
  private let boardScreen: BoardViewController = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    setupUI()
    setupGestures()
    hold { navigate() }
  }

  private func hold(_ completion: AnonymousClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
      navigate()
    }
  }

  private func navigate() {
    pushViewController(boardScreen, animated: true)
  }
}

// MARK: - UI

extension RootNavigationController {
  private func setupUI() {
    navigationBar.tintColor = .systemTeal
  }
}

// MARK: - Gestures

extension RootNavigationController {
  private func setupGestures() {
    edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
    edgeSwipeGestureRecognizer!.edges = .left
    view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
  }

  @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    // First we calculate how far the user has swiped.
    let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width

    if gestureRecognizer.state == .began {
      // If the gesture just began, we create the interaction controller, then begin the transition by calling popViewController(animated:).
      interactionController = UIPercentDrivenInteractiveTransition()
      popViewController(animated: true)
    } else if gestureRecognizer.state == .changed {
      // Whenever the progress changes, we call update(_:) on the interaction controller.
      interactionController?.update(percent)
    } else if gestureRecognizer.state == .ended {
      // When the gesture is complete, we tell the interaction controller to either finish the transition or cancel it, with the finish() and cancel() methods respectively. Finally we set the controller back to nil. We will see why shortly.
      if percent > 0.5, gestureRecognizer.state != .cancelled {
        interactionController?.finish()
      } else {
        interactionController?.cancel()
      }
      interactionController = nil
    }
  }

  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
}
