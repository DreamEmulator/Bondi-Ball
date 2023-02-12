//
//  BoardConfig.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 09/01/2023.
//

import Foundation

struct Board: BoardProtocol {
  var rows: Int
  var columns: Int
  var spring: DampedHarmonicSpring
}
