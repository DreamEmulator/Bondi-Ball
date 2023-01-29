//
//  SetupController.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 01/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

class SetupController: UIViewController {
  @IBOutlet var dampingRatioSlider: UISlider!
  @IBOutlet var frequencyResponseSlider: UISlider!

  @IBOutlet var rowStepper: UIStepper!
  @IBOutlet var rowsLabel: UILabel!
  @IBOutlet var columnStepper: UIStepper!
  @IBOutlet var columnsLabel: UILabel!

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    let config = App.shared.gameState.currentLevel.board
    setupSliderValues(config: config)
    setupGridValues(config: config)
    rowStepper.value = Double(config.rows)
    columnStepper.value = Double(config.columns)
  }

  // MARK: - Setup

  func setupSliderValues(config: Board) {
    dampingRatioSlider.setValue(Float(config.spring.dampingRatio), animated: true)
    frequencyResponseSlider.setValue(Float(config.spring.frequencyResponse), animated: true)
  }

  func setupGridValues(config: Board) {
    rowStepper.value = Double(config.rows)
    rowsLabel.text = String(config.rows)
    columnStepper.value = Double(config.columns)
    columnsLabel.text = String(config.columns)
  }

  // MARK: - Handlers

  func handleChanges() {
    let newConfig = Board(id: "generated", rows: Int(rowStepper.value), columns: Int(columnStepper.value), spring: DampedHarmonicSpring(dampingRatio: CGFloat(dampingRatioSlider.value), frequencyResponse: CGFloat(frequencyResponseSlider.value)))

    rowsLabel.text = String(newConfig.rows)
    columnsLabel.text = String(newConfig.columns)

    App.shared.gameState.updateBoard(config: newConfig)
  }

  @IBAction func dampingRatioChanged(_ sender: UISlider) {
    handleChanges()
  }

  @IBAction func frquencyResponseChanged(_ sender: UISlider) {
    handleChanges()
  }

  @IBAction func rowsChanged(_ sender: UIStepper) {
    handleChanges()
  }

  @IBAction func columnsChanged(_ sender: UIStepper) {
    handleChanges()
  }
}
