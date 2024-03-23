//
//  Game+Sounds.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 12/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

import AVFoundation

// MARK: - Sound effects

extension GameVC {
  func play(sound file: Sounds) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let url = Bundle.main.url(forResource: file.rawValue, withExtension: "m4a") else { return }

      do {

        let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        DispatchQueue.main.async {
          self.player = player
          self.player?.play()
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

// MARK: - Subscribe sound effects

extension GameVC {
  func subscribeSoundEffects() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      let touchedPlayer = try AVAudioPlayer(contentsOf: Sounds.touchedSound.url, fileTypeHint: AVFileType.mp3.rawValue)
      let subscription = App.shared.game.state.subscribe("SoundEffects 🪩") { [weak self] state in
        if let self {
          switch state {
          case .Missed:
            self.play(sound: .missedSound)
          case .Scored:
            self.play(sound: .scoredSound)
          case .Failed:
            self.play(sound: .failedSound)
          case .TouchBall:
            touchedPlayer.play()
          case .FlickedBall:
            self.play(sound: .flickedSound)
          default:
            break
          }
        }
      }
      subscriptions.append(subscription)
    }  catch {
      print(error.localizedDescription)
    }

  }
}
