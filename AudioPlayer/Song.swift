//
//  Song.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 26.12.2021.
//

import Foundation
import AVFoundation

struct Song {
    var name: String
    var format: String
    var albumName: String
    var albumImageData: Data?
    var artist: String
    var songPath: String
    var duration: String
}

extension Song {
    static func getSongList() -> [Song] {
        var songList = [Song]()
        do {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try fm.contentsOfDirectory(atPath: path)
            for item in items {
                if item.hasSuffix("mp3") {
                    if let audioPath = Bundle.main.path(forResource: item.replacingOccurrences(of: ".mp3", with: ""), ofType: "mp3") {
                        let avPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
                        avPlayer.play()
                        let avpItem = AVPlayerItem(url: URL(fileURLWithPath: audioPath))
                        songList.append(Song(name: avpItem.value(for: .commonKeyTitle),
                                             format: "mp3",
                                             albumName: avpItem.value(for: .commonKeyAlbumName),
                                             albumImageData: avpItem.asset.metadata.first(where: {$0.commonKey == .commonKeyArtwork})?.value as? Data,
                                             artist: avpItem.value(for: .commonKeyArtist),
                                             songPath: audioPath,
                                             duration: avPlayer.duration.songDurationFormat()))
                    }
                }
            }
        } catch {
            print(error)
        }
        return songList
    }
    
}
