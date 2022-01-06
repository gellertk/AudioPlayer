//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 26.12.2021.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {
    
    lazy var imgAlbum: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var btnClose: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(systemName: "chevron.down", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblVcTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .lightGray
        lbl.text = "Playing for album"
        return lbl
    }()
    
    lazy var lblAlbum: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    lazy var btnShare: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(didTapShareBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblArtist: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    lazy var lblSong: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return lbl
    }()
    
    lazy var lblTimeFromStart: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lbl.alpha = 0.5
        lbl.textColor = .lightGray
        lbl.text = "00:00"
        return lbl
    }()
    
    lazy var lblTimeToFinish: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lbl.alpha = 0.5
        lbl.textColor = .lightGray
        lbl.text = "00:00"
        return lbl
    }()
    
    lazy var sldrProgress: UISlider = {
        let sldr = CustomSlider(thumbRadius: 8)
        sldr.addTarget(self, action: #selector(didTapThumb(sender:)), for: .touchDown)
        sldr.addTarget(self, action: #selector(progressScrubbed(sender:)), for: .valueChanged)
        return sldr
    }()
    
    lazy var sldrVolume: UISlider = {
        let sldr = CustomSlider(thumbRadius: 20)
        sldr.addTarget(self, action: #selector(volumeDidChange(sender:)), for: .valueChanged)
        return sldr
    }()
    
    lazy var imgVolumeEmpty: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "speaker.fill")
        img.tintColor = .black
        return img
    }()
    
    lazy var imgVolumeFull: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "speaker.wave.3.fill")
        img.tintColor = .black
        return img
    }()
    
    lazy var btnShuffle: UIButton = {
        let btn = UIButton()
        btn.tintColor = .lightGray
        btn.setImage(UIImage(systemName: "shuffle"), for: .normal)
        btn.addTarget(self, action: #selector(didTapShuffleBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnPrevious: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(didTapPreviousBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnNext: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(didTapNextBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnPlayPause: UIButton = {
        let btn = UIButton()
        btn.tintColor = .black
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(didTapPlayPauseBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackSongAction: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [btnPrevious, btnPlayPause, btnNext])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var btnRepeat: UIButton = {
        let btn = UIButton()
        btn.tintColor = .lightGray
        btn.setImage(UIImage(systemName: "repeat"), for: .normal)
        return btn
    }()
    
    var player = AVAudioPlayer()
    var timer: Timer?
    var songs: [Song]
    var playingIndex: Int
    
    init(songs: [Song], playingIndex: Int) {
        self.playingIndex = playingIndex
        self.songs = songs
        super.init(nibName: nil, bundle: nil)
        setupView()
        didTapPlayPauseBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayer() {
        let turnOnAfterSetup = player.isPlaying
        imgAlbum.image = UIImage(data: songs[playingIndex].albumImageData ?? Data()) ?? UIImage(named: "EmptyAlbum")
        lblAlbum.text = songs[playingIndex].albumName
        lblSong.text = songs[playingIndex].name
        lblArtist.text = songs[playingIndex].artist
        do {
            try player = AVAudioPlayer(contentsOf: songs[playingIndex].songURL)
            player.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player.volume = sldrVolume.value
            if turnOnAfterSetup {
                play()
            }
            if timer == nil {
                Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func updateProgress() {
        sldrProgress.value = Float(player.currentTime)
        let remainingTime = player.duration - player.currentTime
        lblTimeFromStart.text = player.currentTime.getFormattedTime()
        lblTimeToFinish.text = "-\(remainingTime.getFormattedTime())"
    }
    
    @objc func progressScrubbed(sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc func volumeDidChange(sender: UISlider) {
        player.volume = Float(sender.value)
    }
    
    func setupView() {
        view.backgroundColor = .white
        sldrVolume.value = 0.5
        setupPlayer()
        [imgAlbum, btnClose, lblVcTitle, lblAlbum, btnShare, lblArtist, lblSong, btnShuffle, stackSongAction, btnRepeat, sldrProgress, sldrVolume, lblTimeFromStart, lblTimeToFinish, imgVolumeEmpty, imgVolumeFull, sldrVolume].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        setupConstraints()
    }
    
    func setPlayPauseImg() {
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        btnPlayPause.setImage(UIImage(systemName: player.isPlaying ? "pause.fill" : "play.fill", withConfiguration: config), for: .normal)
    }
    
    func play() {
        sldrProgress.maximumValue = Float(player.duration)
        player.play()
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            btnClose.widthAnchor.constraint(equalToConstant: 35),
            btnClose.heightAnchor.constraint(equalToConstant: 20),
            btnClose.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            btnClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            lblVcTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            lblVcTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lblAlbum.topAnchor.constraint(equalTo: lblVcTitle.bottomAnchor, constant: 3),
            lblAlbum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btnShare.widthAnchor.constraint(equalToConstant: 30),
            btnShare.heightAnchor.constraint(equalToConstant: 30),
            btnShare.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            btnShare.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            imgAlbum.trailingAnchor.constraint(equalTo: btnShare.trailingAnchor),
            imgAlbum.leadingAnchor.constraint(equalTo: btnClose.leadingAnchor),
            imgAlbum.topAnchor.constraint(equalTo: lblAlbum.bottomAnchor, constant: 15),
            imgAlbum.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
            
            lblSong.topAnchor.constraint(equalTo: imgAlbum.bottomAnchor, constant: 25),
            lblSong.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lblArtist.topAnchor.constraint(equalTo: lblSong.bottomAnchor, constant: 5),
            lblArtist.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lblTimeFromStart.leadingAnchor.constraint(equalTo: imgAlbum.leadingAnchor),
            lblTimeFromStart.topAnchor.constraint(equalTo: lblArtist.bottomAnchor, constant: 25),
            
            lblTimeToFinish.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            lblTimeToFinish.centerYAnchor.constraint(equalTo: lblTimeFromStart.centerYAnchor),
            
            sldrProgress.topAnchor.constraint(equalTo: lblTimeFromStart.bottomAnchor, constant: 3),
            sldrProgress.leadingAnchor.constraint(equalTo: imgAlbum.leadingAnchor),
            sldrProgress.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            
            btnShuffle.leadingAnchor.constraint(equalTo: sldrProgress.leadingAnchor),
            btnShuffle.topAnchor.constraint(equalTo: sldrProgress.bottomAnchor, constant: 40),
            
            stackSongAction.centerYAnchor.constraint(equalTo: btnShuffle.centerYAnchor),
            stackSongAction.leadingAnchor.constraint(equalTo: btnShuffle.trailingAnchor, constant: 40),
            stackSongAction.trailingAnchor.constraint(equalTo: btnRepeat.leadingAnchor, constant: -40),
            
            btnRepeat.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            btnRepeat.centerYAnchor.constraint(equalTo: btnNext.centerYAnchor),
            
            imgVolumeEmpty.leadingAnchor.constraint(equalTo: imgAlbum.leadingAnchor),
            imgVolumeEmpty.topAnchor.constraint(equalTo: btnShuffle.bottomAnchor, constant: 45),
            
            imgVolumeFull.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            imgVolumeFull.centerYAnchor.constraint(equalTo: imgVolumeEmpty.centerYAnchor),
            
            sldrVolume.leadingAnchor.constraint(equalTo: imgVolumeEmpty.trailingAnchor, constant: 20),
            sldrVolume.trailingAnchor.constraint(equalTo: imgVolumeFull.leadingAnchor, constant: -20),
            sldrVolume.centerYAnchor.constraint(equalTo: imgVolumeEmpty.centerYAnchor)
        ])
    }
    
    @objc func didTapThumb(sender: UISlider) {
        //
        //        sldrVolume = CustomSlider(thumbRadius: 20)
        //        sldrVolume.removeFromSuperview()
        //        view.addSubview(sldrVolume)
    }
    
    @objc func didTapCloseBtn() {
        stop()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapShareBtn(_ sender: UIButton) {
        guard let image = imgAlbum.image, let url = URL(string: "http://www.github.com/kgellert/") else {
            return
        }
        let shareSheetVC = UIActivityViewController(activityItems: [image, url], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = sender
        shareSheetVC.popoverPresentationController?.sourceRect = sender.frame
        present(shareSheetVC, animated: true)
    }
    
    @objc func didTapShuffleBtn() {
        //btnShuffle.imageView?.image = 
    }
    
    @objc func didTapNextBtn() {
        playingIndex += 1
        if playingIndex == songs.count {
            playingIndex = 0
        }
        setupPlayer()
        setPlayPauseImg()
    }
    
    @objc func didTapPreviousBtn() {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = songs.count - 1
        }
        setupPlayer()
        setPlayPauseImg()
    }
    
    @objc func didTapPlayPauseBtn() {
        if player.isPlaying {
            stop()
        } else {
            play()
        }
        setPlayPauseImg()
    }
    
}


