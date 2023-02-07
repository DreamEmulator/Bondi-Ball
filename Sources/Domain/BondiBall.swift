//
//  BondiBall.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import UIKit

/// The different states the PIP view can be in.
enum BondiBallState {
  /// Starting scenario
  case initial
  /// The Bondi ball view is at rest at the specified endpoint.
  case idle(at: PocketView)

  /// The user is actively moving the Bondi ball view starting from the specified
  /// initial position using the specified gesture recognizer.
  case interaction(with: UIPanGestureRecognizer, from: CGPoint)

  /// The Bondi ball view is being animated towards the specified endpoint with
  /// the specified animator.
  case animating(to: PocketView, using: UIViewPropertyAnimator)
}
