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

class GameVC: UIViewController, UIGestureRecognizerDelegate {
  // MARK: - Outlets

  @IBOutlet var costMeter: UIProgressView!
  @IBOutlet var gridCollectionView: UICollectionView!

  // MARK: - Vars

  private var level: Level { App.shared.game.level }
  private var spring: DampedHarmonicSpring { App.shared.game.level.board.spring }
  private let paintBall: BondiBallView = .init()
  private var pockets: [PocketView] = .init()

  private var skView = SKView()
  private let magicParticles = SKEmitterNode(fileNamed: "MagicParticles")

  var player: AVAudioPlayer?

  private let panGestureRecognizer: UIPanGestureRecognizer = PanGestureRecognizer()
  private let springConfigurationButton: UIButton = .init(style: .alpha)

  var cellWidth: CGFloat { gridCollectionView.frame.width / CGFloat(App.shared.game.level.board.columns) }
  var cellHeight: CGFloat { gridCollectionView.frame.height / CGFloat(App.shared.game.level.board.rows) }
  var pocktetSize: CGFloat { min(cellHeight, cellWidth) * 0.9 }

  // MARK: - Ball state

  /// The current state of the Bondi Ball
  private var state: BondiBallState = .initial

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
}

// MARK: - Setup UI

extension GameVC {
  private func setupUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.subviews.forEach { $0.removeFromSuperview() }
    if let game = UINib.game.firstView(owner: self) {
      view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
      view.addSubview(game, pinTo: .layoutMargins)
    }
    createListOfPockets()
  }

  private func createListOfPockets() {
    pockets = .init()
    for _ in 0 ... (App.shared.game.level.board.columns * App.shared.game.level.board.rows - 1) {
      pockets.append(PocketView())
    }
    setUpCollectionView()
  }

  private func setUpCollectionView() {
    gridCollectionView
      .register(UICollectionViewCell.self,
                forCellWithReuseIdentifier: "cell")

    gridCollectionView.delegate = self
    gridCollectionView.dataSource = self

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 4

    gridCollectionView
      .setCollectionViewLayout(layout, animated: false)

    setupParticles()
  }

  private func setupBall(level: Level) {
    let startingPocketIndex = level.startPocket.0 * level.startPocket.1 - 1
    let startingPocketCenter = centerPoint(pocketIndex: startingPocketIndex)

    let ballSize = pocktetSize * 0.8
    paintBall.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)

    paintBall.center = startingPocketCenter
    springConfigurationButton.center = startingPocketCenter

    view.addSubview(paintBall)

    configureGestureRecognizers()
  }
}

// MARK: - Grid laypout

extension GameVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return App.shared.game.level.board.rows * App.shared.game.level.board.columns
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

    let pocket = pockets.remove(at: indexPath.row)

    pocket.translatesAutoresizingMaskIntoConstraints = false
    pocket.globalCenter = gridCollectionView.convert(cell.center, to: view)
    pocket.index = indexPath.row

    let containerView = UIView()
    containerView.addSubview(pocket)

    NSLayoutConstraint.activate([
      pocket.heightAnchor.constraint(equalToConstant: pocktetSize),
      pocket.widthAnchor.constraint(equalToConstant: pocktetSize),
      pocket.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      pocket.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ])

    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
    cell.contentView.addSubview(containerView, pinTo: .viewEdges)

    pockets.insert(pocket, at: indexPath.row)
    return cell
  }
}

extension GameVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let lay = collectionViewLayout as! UICollectionViewFlowLayout
    let widthPerItem = collectionView.frame.width / CGFloat(App.shared.game.level.board.columns) - lay.minimumInteritemSpacing
    let heightPerItem = collectionView.frame.height / CGFloat(App.shared.game.level.board.rows) - lay.minimumInteritemSpacing
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
}

// MARK: - Subscribe

extension GameVC {
  func subscribe() {
    App.shared.game.state.subscribe { [weak self] state in
      print(state)
      let progress = 1 - Float(App.shared.game.level.costIncurred) / Float(App.shared.game.level.points)

      switch state {
      case .LevelingUp:
        self?.createListOfPockets()
      case .Playing:
        self?.setupUI()
        self?.gridCollectionView.reloadData()
      case .Dragging:
        self?.costMeter.setProgress(progress, animated: true)
      case .Missed:
        self?.costMeter.setProgress(progress, animated: true)
        self?.play(sound: .missedSound)
        break
      case .Scored:
        self?.play(sound: .scoredSound)
        break
      default:
        break
      }
    }
  }
}

// MARK: - Game management

extension GameVC {
  func updateGame(_ endpoint: PocketView?) {
    guard let endpoint else { return }
    if endpoint.isGoal {
      App.shared.game.state.score()
    } else {
      App.shared.game.state.missed()
    }
  }
}

// MARK: - Gesture Management

extension GameVC {
  func configureGestureRecognizers() {
    panGestureRecognizer.addTarget(self, action: #selector(panGestureDidChange))
    panGestureRecognizer.delegate = self

    paintBall.addGestureRecognizer(panGestureRecognizer)
  }

  @objc private func panGestureDidChange(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      beginInteractiveTransition(with: gesture)
    case .changed:
      updateInteractiveTransition(with: gesture)
    case .ended, .cancelled:
      endInteractiveTransition(with: gesture)
    default:
      break
    }
  }

  public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
    if gesture === panGestureRecognizer {
      // `UIPanGestureRecognizer`s seem to delay their 'began' callback by
      // up to 0.75sec near the edges of the screen. We want to get
      // notified immediately so that we can properly interrupt an ongoing
      // animation.
      DispatchQueue.main.async {
        self.panGestureDidChange(self.panGestureRecognizer)
      }
    }

    return true
  }
}

// MARK: - Interaction Management

extension GameVC {
  /// Get the center position of the pocket in the view coordinatespace
  func centerPoint(pocketIndex: Int) -> CGPoint {
    pockets[pocketIndex].globalCenter
  }

  /// Initiates a new interactive transition that will be driven by the
  /// specified pan gesture recognizer. If an animation is currently in
  /// progress, it is cancelled on the spot.
  func beginInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    switch state {
    case .idle: break
    case .interaction: return
    case .animating(to: _, using: let animator):
      animator.stopAnimation(true)
    case .initial:
      break
    }

    let startPoint = paintBall.center

    state = .interaction(with: gesture, from: startPoint)

    fingerOnBallHaptic()
  }

  /// Updates the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func updateInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: let startPoint) = state else { return }

    let scale = fmax(traitCollection.displayScale, 1)
    let translation = gesture.translation(in: view)

    var center = startPoint + CGVector(to: translation)
    center.x = round(center.x * scale) / scale
    center.y = round(center.y * scale) / scale
    App.shared.game.state.dragging()
    paintBall.center = center
  }

  /// Finishes the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func endInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: _) = state else { return }

    let velocity = CGVector(to: gesture.velocity(in: view))
    let currentCenter = paintBall.center
    let targetCenter = intendedEndpoint(with: velocity, from: currentCenter)

    guard let targetCenter else { return }

    let targetPocket = endpoint(closestTo: targetCenter)
    let parameters = spring.timingFunction(withInitialVelocity: velocity, from: &paintBall.center, to: targetCenter, context: self)
    let animator = UIViewPropertyAnimator(duration: 0, timingParameters: parameters)

    animator.addAnimations {
      self.paintBall.center = targetCenter
    }

    // MARK: - Ball has come to rest

    animator.addCompletion { _ in
      self.ballInPocketHaptic()
      self.updateGame(targetPocket)
      self.state = .idle(at: targetCenter)
    }

    state = .animating(to: targetCenter, using: animator)

    animator.startAnimation()
    releaseBallHaptic(withVelocity: velocity)
  }

  /// Calculates the endpoint to which the PIP view should move from the
  /// specified current position with the specified velocity.
  private func intendedEndpoint(with velocity: CGVector, from currentPosition: CGPoint) -> CGPoint? {
    var velocity = velocity

    // Reduce movement along the secondary axis of the gesture.
    if velocity.dx != 0 || velocity.dy != 0 {
      let velocityInPrimaryDirection = fmax(abs(velocity.dx), abs(velocity.dy))

      velocity.dx *= abs(velocity.dx / velocityInPrimaryDirection)
      velocity.dy *= abs(velocity.dy / velocityInPrimaryDirection)
    }

    let projectedPosition = UIGestureRecognizer.project(velocity, onto: currentPosition)

    let endpoint = self.endpoint(closestTo: projectedPosition)

    return endpoint?.globalCenter
  }

  /// Returns the endpoint closest to the specified point.
  private func endpoint(closestTo point: CGPoint) -> PocketView? {
    pockets.min { pocket in
      pocket.globalCenter.distance(to: point)
    }
  }
}

// - MARK: Haptics
extension GameVC {
  func fingerOnBallHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
  }

  func releaseBallHaptic(withVelocity velocity: CGVector) {
    if velocity.length > 1 {
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred()
    }
  }

  func ballInPocketHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
  }
}

// MARK: - Particle effects

extension GameVC {
  private func setupParticles() {
    skView.removeFromSuperview()
    skView = SKView(frame: view.frame)
    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.isUserInteractionEnabled = false
    skView.scene?.view?.isUserInteractionEnabled = false
    magicParticles?.position = skView.center

    view.backgroundColor = .clear
    view.addSubview(skView)

    NSLayoutConstraint.activate([
      skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      skView.topAnchor.constraint(equalTo: view.topAnchor),
      skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    setupSceneView()
    setupScene()
  }

  private func setupSceneView() {
    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.scene?.backgroundColor = .clear
    skView.scene?.view?.frame = view.frame
    skView.backgroundColor = .clear
    skView.allowsTransparency = true
  }

  private func setupScene() {
    let scene = MagicParticlesScene(size: view.frame.size)
    scene.scaleMode = .aspectFill
    scene.backgroundColor = .clear
    skView.presentScene(scene)
  }
}

// MARK: - Sound effects

extension GameVC {
  func play(sound file: Sounds) {
    guard let url = Bundle.main.url(forResource: file.rawValue, withExtension: "m4a") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      /* iOS 10 and earlier require the following line:
       player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

      guard let player = player else { return }

      player.play()

    } catch {
      print(error.localizedDescription)
    }
  }
}
