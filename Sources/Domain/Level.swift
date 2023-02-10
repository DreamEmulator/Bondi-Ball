//
//  Level.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 16/01/2023.
//  Copyright © 2023 Christian Schnorr. All rights reserved.
//

import Foundation

struct Level: LevelProtocol {
  var id: String
  var board: Board
  var dragCost: Int
  var wrongPocketCost: Int
  var pocketHistory: [PocketView]
  var startPocket: (Int, Int)
  var endPocket: (Int, Int) // TODO: Rename to goal pocket
  var costIncurred: Int
  var points: Int
  var pocketCount: Int { board.rows * board.columns }

  init(id: String,
       board: Board,
       dragCost: Int,
       wrongPocketCost: Int,
       pocketHistory: [PocketView],
       startPocket: (Int, Int),
       endPocket: (Int, Int),
       costIncurred: Int,
       points: Int)
  {
    self.id = id
    self.board = board
    self.dragCost = dragCost
    self.wrongPocketCost = wrongPocketCost
    self.pocketHistory = pocketHistory
    self.startPocket = startPocket
    self.endPocket = endPocket
    self.costIncurred = costIncurred
    self.points = points
  }
}
