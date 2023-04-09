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
  internal var unsubscribeSoundEffects: AnonymousClosure?
  internal var unsubscribeLevel: AnonymousClosure?

  // MARK: - Outlets

  @IBOutlet var costMeter: UIProgressView!
  @IBOutlet var gridCollectionView: UICollectionView? = nil

  // MARK: - Vars

  internal var level: Level { App.shared.game.level }
  internal var spring: DampedHarmonicSpring { App.shared.game.level.board.spring }
  internal let paintBall: BondiBallView = .init()
  internal var pocketViewData: [PocketViewData] = .init()

  internal var skView = SKView()
  internal var scene = SKScene()

  internal var player: AVAudioPlayer?

  internal let panGestureRecognizer: UIPanGestureRecognizer = PanGestureRecognizer()
  internal let springConfigurationButton: UIButton = .init(style: .alpha)

  internal var cellWidth: CGFloat { if let gridCollectionView { return gridCollectionView.frame.width / CGFloat(App.shared.game.level.board.columns) } else { return 0 } }
  internal var cellHeight: CGFloat { if let gridCollectionView { return gridCollectionView.frame.height / CGFloat(App.shared.game.level.board.rows) } else { return 0 } }
  internal var pocktetSize: CGRect { let ps = min(cellHeight, cellWidth) * 0.9; return CGRect(x: 0, y: 0, width: ps, height: ps) }

  // MARK: - Ball state

  /// The current state of the Bondi Ball
  internal var state: BondiBallState = .initial

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI(pocketSize: pocktetSize)
    subscribe()
  }

  override func viewDidLayoutSubviews() {
//    setupBall(level: level)
      setupBall()
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setupUI(pocketSize: pocktetSize)
  }

  deinit {
    unsubscribe?()
  }
}

// MARK: - Subscribe is called on viewDidLoad and wires up the VC to the states of the game

extension GameVC {
  func subscribe() {
    subscribeLevel()
    subscribeSoundEffects()
  }
}
