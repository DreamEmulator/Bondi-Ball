//
//  SetupController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 01/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class SetupController: UIViewController {
  var dampingRatio: Double
  var frequencyResponse: Double

  @IBOutlet var dampingRatioSlider: UISlider!
  @IBOutlet var frequencyResponseSlider: UISlider!
  
  var dampedHarmonicSpring: DampedHarmonicSpring {
    get { DampedHarmonicSpring(dampingRatio: dampingRatio, frequencyResponse: frequencyResponse) }
    set {
      dampingRatio = newValue.dampingRatio
      frequencyResponse = newValue.frequencyResponse
    }
  }

  override func viewDidLayoutSubviews() {
    self.dampingRatioSlider.setValue(Float(dampingRatio), animated: true)
    self.frequencyResponseSlider.setValue(Float(frequencyResponse), animated: true)
  }

  init(dampingRatio: Double, frequencyResponse: Double) {
    self.dampingRatio = dampingRatio
    self.frequencyResponse = frequencyResponse
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @IBAction func dampingRatioChanged(_ sender: UISlider) {
    dampedHarmonicSpring = DampedHarmonicSpring(dampingRatio: dampedHarmonicSpring.dampingRatio, frequencyResponse: CGFloat(sender.value))
  }

  @IBAction func frquencyResponseChanged(_ sender: UISlider) {
    dampedHarmonicSpring = DampedHarmonicSpring(dampingRatio: CGFloat(sender.value), frequencyResponse: dampedHarmonicSpring.frequencyResponse)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */
}
