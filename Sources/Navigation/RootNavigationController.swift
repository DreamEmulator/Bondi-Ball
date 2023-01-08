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
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
}
