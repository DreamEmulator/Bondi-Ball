//
//  ViewController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate, StateSubscriber {
  var unsubscribe: AnonymousClosure?

  // MARK: - Visuals

  private let splashScreen: SplashViewController = .init()
  private var gameVC: GameVC = .init()
  private var scoreVC: ScoreVC = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    setupUI()
    hold { self.pushViewController(self.gameVC, animated: true) }
//    subscribe()
  }

  deinit {
    unsubscribe?()
  }
}

// MARK: - Subscription

extension RootNavigationController {
  func subscribe() {
    // MARK: - Navigation is managed here and not in the viewcontrollers themselves

    self.unsubscribe = App.shared.game.state.subscribe { [weak self] state in
      if let self {
        switch state {
        case .Scored:
          self.hold(for: 1.75) {
            self.presentScoreVC()
          }
        case .Playing:
          self.presentGameVC()
        case .RetryingLevel:
          self.presentGameVC()
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
  private func hold(for time: TimeInterval = 1.0, _ completion: @escaping AnonymousClosure) {
    Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
      completion()
    }
  }

  private func presentGameVC() {
    self.gameVC.unsubscribe?()
    self.gameVC = GameVC()
    self.pushViewController(self.gameVC, animated: true)
  }

  private func presentScoreVC() {
    self.scoreVC.unsubscribe?()
    self.scoreVC = ScoreVC()
    self.pushViewController(self.scoreVC, animated: true)
  }
}
