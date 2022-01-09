
//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 30.12.2021.
//

import UIKit

class PlayerViewController: UIViewController {
    
    let songs: [Song]
    let playingIndex: Int
    
    lazy var mediaPlayer : MediaPlayer = {
        let v = MediaPlayer(songs: songs, playingIndex: playingIndex, playerVC: self)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    init(songs: [Song], playingIndex: Int) {
        self.songs = songs
        self.playingIndex = playingIndex
        super.init(nibName: nil, bundle: nil)
        view.addSubview(mediaPlayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        view.addSubview(mediaPlayer)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPlayer.stop()
    }
    
}
