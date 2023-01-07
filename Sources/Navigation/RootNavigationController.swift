//
//  ViewController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
  private let splashScreen: SplashViewController = .init()
  private let boardScreen: BoardViewController = .init()

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
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
