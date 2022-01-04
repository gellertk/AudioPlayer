//
//  AVPlayerItemExtensions.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 02.01.2022.
//

import AVFoundation

extension AVPlayerItem {
    func value(for key: AVMetadataKey) -> String {
        let songMetaData = self.asset.metadata
        return songMetaData.first(where: {$0.commonKey == key})?.value as? String ?? ""
    }
}
