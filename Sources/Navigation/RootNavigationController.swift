//
//  ViewController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
  // MARK: - Visuals

  private let splashScreen: SplashViewController = .init()
  private let levelScreen: LevelViewController = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    setupUI()
    hold { navigate() }
  }

  private func hold(_ completion: AnonymousClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
      navigate()
    }
  }

  private func navigate() {
    pushViewController(levelScreen, animated: true)
  }
}

// MARK: - UI

extension RootNavigationController {
  private func setupUI() {
    navigationBar.tintColor = .systemTeal
  }
}
