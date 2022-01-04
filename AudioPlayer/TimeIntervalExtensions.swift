//
//  TimeIntervalExtensions.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 03.01.2022.
//

import Foundation

extension TimeInterval {
    func songDurationFormat() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: self) ?? "0:00"
    }
}
