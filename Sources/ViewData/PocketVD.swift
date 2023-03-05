//
//  PocketVD.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 03/03/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation

struct PocketViewData: PocketProtocol {
  var position: [Position : Int]

  var displayPosition: CGPoint

  var isGoal: Bool

  var isStartPocket: Bool

  var scored: Bool

}
