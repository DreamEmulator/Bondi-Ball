//
//  Level.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 16/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import Foundation

struct Level: BoardProtocol, LevelProtocol {
  var id = UUID()
  var rows: Int
  var columns: Int
  var spring: DampedHarmonicSpring
  var dragCost: Int
  var wrongPocketCost: Int
  var pocketHistory: [EndpointIndicatorView]
  var startPocket: (Int, Int)
  var endPocket: (Int,Int)
  var costIncurred: Int
  var points: Int

  init(board: Board,
       dragCost: Int,
       wrongPocketCost: Int,
       pocketHistory: [EndpointIndicatorView],
       startPocket: (Int, Int),
       endPocket: (Int, Int),
       costIncurred: Int,
       points: Int)
  {
    self.id = UUID()
    self.rows = board.rows
    self.columns = board.columns
    self.spring = board.spring
    self.dragCost = dragCost
    self.wrongPocketCost = wrongPocketCost
    self.pocketHistory = pocketHistory
    self.startPocket = startPocket
    self.endPocket = endPocket
    self.costIncurred = costIncurred
    self.points = points
  }
}
