//
//  PocketVD.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 03/03/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import Foundation

struct PocketViewData: PocketProtocol {

  var id: IndexPath = .init()

  var position: [Position : Int] = .init()

  var displayPosition: CGPoint = .init()

  var isGoal: Bool = .init()

  var isStartPocket: Bool = .init()

  var scored: Bool = .init()
}
