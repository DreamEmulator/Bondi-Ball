//
//  SplashViewController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 06/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UINavigationControllerDelegate {
  private var interactionController: UIPercentDrivenInteractiveTransition?
  var imageView = UIImageView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    // Background
    view.backgroundColor = .systemBackground

    // V-Stack
    let vStack = UIStackView()
    vStack.distribution = .equalSpacing
    vStack.axis = .vertical

    // Image
    let image = UIImage(named: "BondiBallElipse")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = image

    // Compose
    view.addSubview(vStack)
    vStack.addSubview(imageView)

    // Constraints
    NSLayoutConstraint.activate([
      // VStack
      vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      vStack.topAnchor.constraint(equalTo: view.topAnchor),
      vStack.topAnchor.constraint(equalTo: view.bottomAnchor),
      // Image
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 256),
      imageView.heightAnchor.constraint(equalToConstant: 256),
    ])
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
}

extension SplashViewController {
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
}
