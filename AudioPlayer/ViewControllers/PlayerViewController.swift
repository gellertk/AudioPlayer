//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 26.12.2021.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var currentSong: Song
    
    var imgAlbum: UIImageView = {
        return UIImageView()
    }()
    
    init(currentSong: Song) {
        self.currentSong = currentSong
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
}

