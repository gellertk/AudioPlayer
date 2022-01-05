//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 26.12.2021.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var currentSong: Song
    lazy var mediaPlayer: UIView = {
        let view = MediaPlayer(currentSong: currentSong)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(mediaPlayer)
        setupConstraints()
        //print((mediaPlayer.subviews[0] as? UIImageView)?.image)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

