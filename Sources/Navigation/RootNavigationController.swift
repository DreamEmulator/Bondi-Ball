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
//  private let levelScreen: LevelViewController = .init()
  private let gameVC: GameVC = .init()
  private let scoreVC: ScoreVC = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    setupUI()
    hold { self.pushViewController(self.gameVC, animated: true) }
    subscribe()
  }

  private func subscribe() {
    // MARK: - Navigation is managed here and not in the viewcontrollers themselves

    App.shared.game.state.subscribe { [weak self] state in
      if let self {
        switch state {
        case .Scored:
          self.pushViewController(self.scoreVC, animated: true)
        case .Playing:
          self.popViewController(animated: true)
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
  }
}

// MARK: - Navigation

extension RootNavigationController {
  private func hold(_ completion: @escaping AnonymousClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      completion()
    }
  }
}
