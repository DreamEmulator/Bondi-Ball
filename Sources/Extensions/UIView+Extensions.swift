//
//  UIView+Extensions.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 06/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import UIKit

extension UIView {
  // MARK: - Border styling

  /// Make it possible to add a borderRadius in StoryBoards
  @IBInspectable var cornerRadiusV: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

  /// Make it possible to add a border in StoryBoards
  @IBInspectable var borderWidthV: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColorV: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
}

//  Copyright © 2020 Sander de Vos. All rights reserved.

protocol LayoutGuide {
  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}

public enum LayoutGuideType {
  case viewEdges
  case layoutMargins
  case safeArea
  case readableContent
}

public struct EdgeLayoutGuides {
  public let top: LayoutGuideType
  public let leading: LayoutGuideType
  public let bottom: LayoutGuideType
  public let trailing: LayoutGuideType

  public static var viewEdges: Self { .layoutGuides(.viewEdges) }
  public static var layoutMargins: Self { .layoutGuides(.layoutMargins) }
  public static var safeArea: Self { .layoutGuides(.safeArea) }
  public static var readableContent: Self { .layoutGuides(.readableContent) }

  public static func layoutGuides(_ topTrailingBottomLeading: LayoutGuideType)
    -> Self { Self(top: topTrailingBottomLeading, leading: topTrailingBottomLeading, bottom: topTrailingBottomLeading, trailing: topTrailingBottomLeading) }
  public static func layoutGuides(_ topBottom: LayoutGuideType,
                                  _ trailingLeading: LayoutGuideType) -> Self { Self(top: topBottom, leading: trailingLeading, bottom: topBottom, trailing: trailingLeading) }
  public static func layoutGuides(_ top: LayoutGuideType, _ trailingLeading: LayoutGuideType,
                                  _ bottom: LayoutGuideType) -> Self { Self(top: top, leading: trailingLeading, bottom: bottom, trailing: trailingLeading) }
  public static func layoutGuides(_ top: LayoutGuideType, _ trailing: LayoutGuideType, _ bottom: LayoutGuideType,
                                  _ leading: LayoutGuideType) -> Self { Self(top: top, leading: leading, bottom: bottom, trailing: trailing) }
}

public struct EdgeConstraints {
  public let top: NSLayoutConstraint
  public let trailing: NSLayoutConstraint
  public let bottom: NSLayoutConstraint
  public let leading: NSLayoutConstraint
}

/// Examples:
/// addSubview(view, pinTo: .readableContent)
/// addSubview(view, pinTo: .readableContent, .insets(10))
/// addSubview(view, pinTo: .constraints(.viewEdges, .safeArea), .insets(10, 30))
/// addSubview(view, pinTo: .constraints(.viewEdges, .safeArea), .insetBottom(10))

public extension UIView {
  @discardableResult
  func addSubview(_ view: UIView, pinTo edgeLayoutGuides: EdgeLayoutGuides, insets: NSDirectionalEdgeInsets = .zero, modify: ((EdgeConstraints) -> Void)? = nil) -> EdgeConstraints {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)

    let edgeConstraints = EdgeConstraints(
      top: view.topAnchor.constraint(equalTo: layoutGuide(for: edgeLayoutGuides.top).topAnchor, constant: insets.top),
      trailing: layoutGuide(for: edgeLayoutGuides.trailing).trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.trailing),
      bottom: layoutGuide(for: edgeLayoutGuides.bottom).bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
      leading: view.leadingAnchor.constraint(equalTo: layoutGuide(for: edgeLayoutGuides.leading).leadingAnchor, constant: insets.leading)
    )

    modify?(edgeConstraints)

    NSLayoutConstraint.activate(
      [edgeConstraints.top, edgeConstraints.trailing, edgeConstraints.leading, edgeConstraints.bottom]
    )

    return edgeConstraints
  }

  private func layoutGuide(for layoutGuideType: LayoutGuideType) -> any LayoutGuide {
    switch layoutGuideType {
    case .viewEdges:
      return self
    case .layoutMargins:
      return layoutMarginsGuide
    case .safeArea:
      return safeAreaLayoutGuide
    case .readableContent:
      return readableContentGuide
    }
  }
}
