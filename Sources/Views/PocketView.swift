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

import UIKit

internal final class PocketView: UIView, StateSubscriber {
  var viewData: PocketViewData

  internal var unsubscribe: AnonymousClosure?

  public init(frame: CGRect, viewData: PocketViewData) {
    self.viewData = viewData
    super.init(frame: frame)
    self.isOpaque = false
    subscribe() // TODO: Fix that this subscribe gets called when fishing for the view from the grid collection
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError()
  }

  deinit {
     unsubscribe?()// TODO: Learn why this deinit is called unexpectedly
  }
}

// MARK: - Subscriptions

extension PocketView {
  func subscribe() {
    unsubscribe = App.shared.game.state.subscribe("Pocket View 👖") { [weak self] state in
      if let self {
        switch state {
        case .Scored:
          self.viewData.scored = true
        default:
          self.viewData.scored = false
        }
      }
      self?.setNeedsDisplay()
    }
  }
}

// MARK: - SetupUI

extension PocketView {
  override public func draw(_ rect: CGRect) {
    let radius = frame.width as CGFloat
    let thickness = 4 as CGFloat

    let bounds = CGRect(origin: .zero, size: self.bounds.size).insetBy(dx: thickness / 2, dy: thickness / 2)
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)

    let context = UIGraphicsGetCurrentContext()!
    context.beginPath()
    context.addPath(path.cgPath)

    if traitCollection.userInterfaceStyle == .dark {
      context.setStrokeColor(UIColor.purple.withAlphaComponent(0.5).cgColor)
    }

    if traitCollection.userInterfaceStyle == .light {
      context.setStrokeColor(UIColor.blue.withAlphaComponent(0.15).cgColor)
    }

    if viewData.isStartPocket {
      rotate(duration: 500)
    }

    if viewData.isGoal {
      context.setStrokeColor(UIColor.magenta.withAlphaComponent(0.5).cgColor)
      rotate(duration: 100)
    }

    if viewData.isGoal, viewData.scored {
      context.setStrokeColor(UIColor.systemMint.withAlphaComponent(0.5).cgColor)
      stopRotating()
      rotate(duration: 20)
    }

    context.setLineDash(phase: 0, lengths: [7])
    context.setLineWidth(thickness)
    context.strokePath()
  }
}
