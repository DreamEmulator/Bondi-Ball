//
//  GameController+LevelProgress.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 30/04/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import AVFoundation

// MARK: - Manage level progress

extension GameController {
  func playSoundtrack() {
    let soundtrackFile = Bundle.main.path(forResource: "🏰 Q-Locked 🗝️", ofType: "m4a")
    guard let soundtrackFile else { return }
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      soundtrackPlayer = AVPlayer(url: URL(fileURLWithPath: soundtrackFile))

      soundtrackPlayer?.play()

    } catch {
      print(error.localizedDescription)
    }
  }
}

// MARK: Subscription - Soundtrack progression

extension GameController {
  func subscribeSoundtrackProgression(state: GameState) {
    switch state {
    case .FlickedBall:
      playSoundtrack()
    default:
      break
    }
  }
}
