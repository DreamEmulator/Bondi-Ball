//
//  SetupController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 01/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

typealias SetSpringCallback = (_ spring: DampedHarmonicSpring) -> Void

class SetupController: UIViewController {
  private var setSpringCallback: SetSpringCallback

  @IBOutlet var dampingRatioSlider: UISlider!
  @IBOutlet var frequencyResponseSlider: UISlider!

  var dampedHarmonicSpring: DampedHarmonicSpring?

  init(setSpringCallback: @escaping SetSpringCallback) {
    self.setSpringCallback = setSpringCallback
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    if let spring = dampedHarmonicSpring {
      setSliderValues(spring: spring)
    }
  }

  // MARK: - Handlers

  @IBAction func dampingRatioChanged(_ sender: UISlider) {
    if let spring = dampedHarmonicSpring {
      let newSpring = DampedHarmonicSpring(dampingRatio: CGFloat(sender.value), frequencyResponse: CGFloat(spring.frequencyResponse))
      setSpringCallback(newSpring)
    }
  }

  @IBAction func frquencyResponseChanged(_ sender: UISlider) {
    if let spring = dampedHarmonicSpring {
      let newSpring = DampedHarmonicSpring(dampingRatio: spring.dampingRatio, frequencyResponse: CGFloat(sender.value))
      setSpringCallback(newSpring)
    }
  }

  func setSliderValues(spring: DampedHarmonicSpring) {
    dampingRatioSlider.setValue(Float(spring.dampingRatio), animated: true)
    frequencyResponseSlider.setValue(Float(spring.frequencyResponse), animated: true)
  }
}
