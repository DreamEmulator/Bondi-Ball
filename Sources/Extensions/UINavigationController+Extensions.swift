//
//  UINavigationController+Extensions.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

extension RootNavigationController {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // Implement navigationController(_:animationControllerFor:from:to:), returning an instance of the animation controller we just created. We can use the operation object to see if it's a push or pop transition, so that the animation can be customized based on this.
    if operation == .push {
      return FadeAnimationController(presenting: false)
    } else {
      return FadeAnimationController(presenting: true)
    }
  }
}
