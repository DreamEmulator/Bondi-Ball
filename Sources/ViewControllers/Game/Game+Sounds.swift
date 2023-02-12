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
    guard let url = Bundle.main.url(forResource: file.rawValue, withExtension: "m4a") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      /* iOS 10 and earlier require the following line:
       player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

      guard let player = player else { return }

      player.play()

    } catch {
      print(error.localizedDescription)
    }
  }
}
