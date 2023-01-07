//
//  Animations.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 07/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

// MARK: - Animation

/// https://medium.com/@ludvigeriksson/custom-interactive-uinavigationcontroller-transition-animations-in-swift-4-a4b5e0cefb1e

// The object needs to inherit from NSObject since UIViewControllerAnimatedTransitioning inherits from NSObjectProtocol.
class FadeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  // This property (set through the initializer) let’s us know whether the transition is happening to present a view controller, or to remove one. We will see later how it’s set.
  private let presenting: Bool

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    // For the duration we return 0.5 seconds.
    return 0.5
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // To get the views we are animating, you can call view(forKey:) on the transitionContext object. There is also viewController(forKey:) if you need to access the view controllers to communicate with them.
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }

    // Here we set the initial state of the animation. It is also our responsibility to add the toView to the view hierarchy. We add it to the containerView of the transitionContext object.
    let container = transitionContext.containerView
    if presenting {
      container.addSubview(toView)
      toView.alpha = 0.0
    } else {
      container.insertSubview(toView, belowSubview: fromView)
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      // Inside UIView's block based API we set the final state of the animation. For the fade animation we simply fade in toView or fade out fromView, but again, this could be anything animatable.
      if self.presenting {
        toView.alpha = 1.0
      } else {
        fromView.alpha = 0.0
      }
    }) { _ in
      // When the animation is complete there are a few things left to do. First, if the transition was cancelled, we are responsible for undoing any changes to the view hierarchy we previously made, so we remove the toView from the view hierarchy. Second, we must call completeTransition(_:) to let the context know that we have finished animating.
      let success = !transitionContext.transitionWasCancelled
      if !success {
        toView.removeFromSuperview()
      }
      transitionContext.completeTransition(success)
    }
  }

  init(presenting: Bool) {
    self.presenting = presenting
  }
}
