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
  private var dampingRatio: Double
  private var frequencyResponse: Double
  private var setSpringCallback: SetSpringCallback

  @IBOutlet var dampingRatioSlider: UISlider!
  @IBOutlet var frequencyResponseSlider: UISlider!

  var dampedHarmonicSpring: DampedHarmonicSpring { DampedHarmonicSpring(dampingRatio: dampingRatio, frequencyResponse: frequencyResponse) }

  override func viewDidLayoutSubviews() {
    dampingRatioSlider.setValue(Float(dampingRatio), animated: true)
    frequencyResponseSlider.setValue(Float(frequencyResponse), animated: true)
  }

  init(dampingRatio: Double, frequencyResponse: Double, setSpringCallback: @escaping SetSpringCallback) {
    self.dampingRatio = dampingRatio
    self.frequencyResponse = frequencyResponse
    self.setSpringCallback = setSpringCallback
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @IBAction func dampingRatioChanged(_ sender: UISlider) {
    frequencyResponse = Double(sender.value)
  }

  @IBAction func frquencyResponseChanged(_ sender: UISlider) {
    dampingRatio = Double(sender.value)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func viewWillDisappear(_ animated: Bool) {
    setSpringCallback(dampedHarmonicSpring)
  }
}
