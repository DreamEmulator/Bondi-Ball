/*
 MIT License

 Copyright (c) 2018 Christian Schnorr

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import AVFAudio
import SpriteKit
import UIKit

internal class BoardViewController: UIViewController, UIGestureRecognizerDelegate {
  // MARK: - Lifecycle

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError()
  }

  // MARK: - Vars

  private let paintBall: BondiBallView = .init()
  private var pockets: [EndpointIndicatorView] = .init()
  private let panGestureRecognizer: UIPanGestureRecognizer = PanGestureRecognizer()
  private var song: AVAudioPlayer?
  private var skView = SKView()
  private let magicParticles = SKEmitterNode(fileNamed: "MagicParticles")
  private var containerStack = UIStackView()
  private let springConfigurationButton: UIButton = .init(style: .alpha)
  private var viewSize: CGSize = .init() {
    didSet {
      self.setupGrid(config: self.boardConfig)
      self.setupParticles(frame: CGRect(x: 0, y: 0, width: self.viewSize.width, height: self.viewSize.height))
    }
  }

  var boardConfig = BoardConfig() { didSet {
    self.setupGrid(config: self.boardConfig)
  }}

  // MARK: - Configuration

  /// The spring driving animations of the PIP view.
  private var spring: DampedHarmonicSpring = .init(dampingRatio: 0.35, frequencyResponse: 0.95)

  // MARK: - State

  /// The different states the PIP view can be in.
  enum State {
    /// Starting scenario
    case initial
    /// The PIP view is at rest at the specified endpoint.
    case idle(at: EndpointIndicatorView)

    /// The user is actively moving the PIP view starting from the specified
    /// initial position using the specified gesture recognizer.
    case interaction(with: UIPanGestureRecognizer, from: CGPoint)

    /// The PIP view is being animated towards the specified endpoint with
    /// the specified animator.
    case animating(to: EndpointIndicatorView, using: UIViewPropertyAnimator)
  }

  /// The current state of the PIP view.
  var state: State = .initial

  // Handlers
  @objc func buttonClicked() {
    let gearController = SetupController {
      config in
      self.boardConfig = config
    }
    gearController.config = self.boardConfig
    present(gearController, animated: true)
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    true
  }
}

// MARK: - Setup

extension BoardViewController {
  private func setupGrid(config: BoardConfig) {
    // Reset
    pockets = .init()
    self.containerStack.removeFromSuperview()
    self.containerStack = UIStackView()

    // Prepare
    self.containerStack.translatesAutoresizingMaskIntoConstraints = false
    self.containerStack.axis = .vertical
    self.containerStack.spacing = 12
    self.containerStack.distribution = .equalSpacing
    self.containerStack.contentMode = .center

    view.addSubview(self.containerStack)

    NSLayoutConstraint.activate([
      containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])

    // Setup
    let pocketSize = CGFloat(Float(min(viewSize.width, viewSize.height)) / Float(max(boardConfig.columns, boardConfig.rows)) - 16)

    for i in 1 ... config.rows {
      let rowStack = UIStackView()
      rowStack.translatesAutoresizingMaskIntoConstraints = false
      rowStack.axis = .horizontal
      rowStack.distribution = .equalSpacing
      rowStack.alignment = .center
      rowStack.spacing = 12
      self.containerStack.addArrangedSubview(rowStack)

      for j in 1 ... config.columns {
        let column = EndpointIndicatorView()
        column.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          column.widthAnchor.constraint(equalToConstant: pocketSize),
          column.heightAnchor.constraint(equalToConstant: pocketSize)
        ])
        rowStack.addArrangedSubview(column)
        pockets.append(column)
        column.name = i * j // TODO: remove
        if i == config.columns { state = .idle(at: pockets.last!) }
      }
    }
  }

  fileprivate func setupButton() {
    view.addSubview(self.springConfigurationButton)

    let button = self.springConfigurationButton
    let buttonSize = CGFloat(Float(min(viewSize.width, viewSize.height)) / Float(max(boardConfig.columns, boardConfig.rows)) - 42)
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: buttonSize),
      button.heightAnchor.constraint(equalToConstant: buttonSize)
    ])
    button.layer.cornerRadius = 0.5 * self.springConfigurationButton.bounds.size.width
    button.clipsToBounds = true

    button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
    button.tintColor = .secondaryLabel
    button.alpha = 0.5
    button.layer.zPosition = -1000
  }

  /// Here you manage the z-layout of the views
  func arrangeViews() {
    view.sendSubviewToBack(skView)
    view.sendSubviewToBack(containerStack)
    view.bringSubviewToFront(paintBall)
  }
}

// MARK: - View Management

extension BoardViewController {
  override public func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.setHidesBackButton(true, animated: true)
    view.backgroundColor = .systemBackground
    viewSize = CGSize(width: view.frame.width, height: view.frame.height)

    setupButton()
    setupGrid(config: self.boardConfig)
    setupParticles(frame: view.frame)
    configureGestureRecognizers()
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    switch self.state {
    case .idle(at: let endpoint):
      self.paintBall.frame = endpoint.frame
    case .animating(to: let endpoint, using: _):
      self.paintBall.frame = endpoint.frame
    case .interaction:
      break
    case .initial:
      break
    }

    let startingPocketIndex = boardConfig.rows * boardConfig.columns - Int(round(Double(boardConfig.columns / 2))) - 1
    let startingPocket = convertToContainerSpace(pocket: pockets[startingPocketIndex])
    paintBall.center = convertToContainerSpace(pocket: pockets[startingPocketIndex])
    springConfigurationButton.center = startingPocket

    view.addSubview(paintBall)
    arrangeViews()
  }

  override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    viewSize = size
  }
}

// MARK: - Gesture Management

extension BoardViewController {
  func configureGestureRecognizers() {
    self.panGestureRecognizer.addTarget(self, action: #selector(self.panGestureDidChange))
    self.panGestureRecognizer.delegate = self

    self.paintBall.addGestureRecognizer(self.panGestureRecognizer)
  }

  @objc private func panGestureDidChange(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.beginInteractiveTransition(with: gesture)
    case .changed:
      self.updateInteractiveTransition(with: gesture)
    case .ended, .cancelled:
      self.endInteractiveTransition(with: gesture)
    default:
      break
    }
  }

  public func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
    if gesture === self.panGestureRecognizer {
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

extension BoardViewController {
  /// Get the center position of the pocket in the view coordinatespace
  func convertToContainerSpace(pocket: EndpointIndicatorView) -> CGPoint {
    pocket.convert(pocket.bounds.center, to: view)
  }

  /// Initiates a new interactive transition that will be driven by the
  /// specified pan gesture recognizer. If an animation is currently in
  /// progress, it is cancelled on the spot.
  func beginInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    switch self.state {
    case .idle: break
    case .interaction: return
    case .animating(to: _, using: let animator):
      animator.stopAnimation(true)
    case .initial:
      break
    }

    let startPoint = self.paintBall.center

    self.state = .interaction(with: gesture, from: startPoint)
  }

  /// Updates the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func updateInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: let startPoint) = self.state else { return }

    let scale = fmax(self.traitCollection.displayScale, 1)
    let translation = gesture.translation(in: self.view)

    var center = startPoint + CGVector(to: translation)
    center.x = round(center.x * scale) / scale
    center.y = round(center.y * scale) / scale
    self.paintBall.center = center
  }

  /// Finishes the ongoing interactive transition driven by the specified pan
  /// gesture recognizer.
  func endInteractiveTransition(with gesture: UIPanGestureRecognizer) {
    guard case .interaction(with: gesture, from: _) = self.state else { return }

    let velocity = CGVector(to: gesture.velocity(in: self.view))
    let currentCenter = self.paintBall.center
    let endpoint = self.intendedEndpoint(with: velocity, from: currentCenter)
    let targetCenter = self.convertToContainerSpace(pocket: endpoint) // TODO: Make sure this is in the global space and not in the UIStack...
    let parameters = self.boardConfig.spring.timingFunction(withInitialVelocity: velocity, from: &self.paintBall.center, to: targetCenter, context: self)
    let animator = UIViewPropertyAnimator(duration: 0, timingParameters: parameters)

    animator.addAnimations {
      self.paintBall.center = targetCenter
    }

    animator.addCompletion { _ in
      self.simpleSuccess()
      self.state = .idle(at: endpoint)
    }

    self.state = .animating(to: endpoint, using: animator)

    animator.startAnimation()
  }

  /// Calculates the endpoint to which the PIP view should move from the
  /// specified current position with the specified velocity.
  private func intendedEndpoint(with velocity: CGVector, from currentPosition: CGPoint) -> EndpointIndicatorView {
    var velocity = velocity

    // Reduce movement along the secondary axis of the gesture.
    if velocity.dx != 0 || velocity.dy != 0 {
      let velocityInPrimaryDirection = fmax(abs(velocity.dx), abs(velocity.dy))

      velocity.dx *= abs(velocity.dx / velocityInPrimaryDirection)
      velocity.dy *= abs(velocity.dy / velocityInPrimaryDirection)
    }

    let projectedPosition = UIGestureRecognizer.project(velocity, onto: currentPosition)

    let endpoint = self.endpoint(closestTo: projectedPosition)

    return endpoint
  }

  /// Returns the endpoint closest to the specified point.
  private func endpoint(closestTo point: CGPoint) -> EndpointIndicatorView {
    let closest = pockets.min(by: { pocket in
      let distance = point.distance(to: convertToContainerSpace(pocket: pocket))
      return distance
    })!
    return closest
  }
}

// MARK: - Particle effects

extension BoardViewController {
  private func setupParticles(frame: CGRect) {
    skView.removeFromSuperview()
    skView = SKView(frame: frame)
    skView.translatesAutoresizingMaskIntoConstraints = false
    skView.isUserInteractionEnabled = false
    skView.scene?.view?.isUserInteractionEnabled = false
    magicParticles?.position = skView.center

    view.backgroundColor = .clear
    view.addSubview(self.skView)

    NSLayoutConstraint.activate([
      skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      skView.topAnchor.constraint(equalTo: view.topAnchor),
      skView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    self.setupSceneView()
    self.setupScene()
    // playSong()
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
    self.skView.presentScene(scene)
  }
}

/// - MARK: Haptics
extension BoardViewController {
  func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
  }
}
