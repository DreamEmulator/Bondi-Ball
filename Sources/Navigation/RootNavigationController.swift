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
  private let levelingUpController: LevellingUpController = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    setupUI()
    hold { navigate() }
    subscribe()
  }

  private func subscribe() {
    // MARK: - Navigation is managed here and not in the viewcontrollers themselves

    App.shared.game.state.subscribe { [weak self] state in
      if let self {
        switch state {
        case .Scored:
          self.present(self.levelingUpController, animated: true)
        case .LevelingUp:
          self.levelingUpController.dismiss(animated: true)
        default:
          break
        }
      }
    }
  }
}

// MARK: - UI

extension RootNavigationController {
  private func setupUI() {
    navigationBar.tintColor = .systemTeal
    levelingUpController.modalPresentationStyle = .overFullScreen
  }
}

// MARK: - Navigation

extension RootNavigationController {
  private func hold(_ completion: AnonymousClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
      navigate()
    }
  }

  private func navigate() {
    pushViewController(levelScreen, animated: true)
  }
}
