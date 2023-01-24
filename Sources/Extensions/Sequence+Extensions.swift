//
//  Sequence+Extensions.swift
//  Gestures-In-Fluid-Interfaces
//
//  Created by Sebastiaan Hols on 01/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import Foundation

public extension Sequence {
  func min<T>(by closure: (Element) throws -> T) rethrows -> Element? where T: Comparable {
    let tuples = try self.lazy.map { (element: $0, value: try closure($0)) }
    let minimum = tuples.min(by: { $0.value < $1.value })

    return minimum?.element
  }
}
