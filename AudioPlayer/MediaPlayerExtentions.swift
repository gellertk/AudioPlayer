//
//  MediaPlayerExtentions.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 06.01.2022.
//

import MediaPlayer

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}
