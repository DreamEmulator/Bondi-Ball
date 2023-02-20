//
//  GameVC.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import AVFoundation
import SpriteKit
import UIKit

typealias GameCallback = (_ level: Level) -> Void

class GameVC: UIViewController, UIGestureRecognizerDelegate, StateSubscriber {
  internal var unsubscribe: AnonymousClosure?

  // MARK: - Outlets

  @IBOutlet var costMeter: UIProgressView!
  @IBOutlet var gridCollectionView: UICollectionView!

  // MARK: - Vars

  internal var level: Level { App.shared.game.level }
  internal var spring: DampedHarmonicSpring { App.shared.game.level.board.spring }
  internal let paintBall: BondiBallView = .init()
  internal var pockets: [PocketView] = .init()

  internal var skView = SKView()

  internal var player: AVAudioPlayer?

  internal let panGestureRecognizer: UIPanGestureRecognizer = PanGestureRecognizer()
  internal let springConfigurationButton: UIButton = .init(style: .alpha)

  internal var cellWidth: CGFloat { gridCollectionView.frame.width / CGFloat(App.shared.game.level.board.columns) }
  internal var cellHeight: CGFloat { gridCollectionView.frame.height / CGFloat(App.shared.game.level.board.rows) }
  internal var pocktetSize: CGFloat { min(cellHeight, cellWidth) * 0.9 }

  // MARK: - Ball state

  /// The current state of the Bondi Ball
  internal var state: BondiBallState = .initial

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    subscribe()
  }

  override func viewDidLayoutSubviews() {
    setupBall(level: level)
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setupUI()
  }

  deinit {
    unsubscribe?()
  }
}
