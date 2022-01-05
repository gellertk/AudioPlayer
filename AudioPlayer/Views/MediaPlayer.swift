//
//  MediaPlayer.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 05.01.2022.
//

import UIKit

class MediaPlayer: UIView {
    
    var currentSong: Song
    
    lazy var imgAlbum: UIImageView = {
        let imgView = UIImageView(image: UIImage(data: currentSong.albumImageData ?? Data()) ?? UIImage(named: "EmptyAlbum"))
        
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
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
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
        lbl.text = currentSong.albumName
        return lbl
    }()
    
    lazy var btnShare: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(share), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblArtist: UILabel = {
        let lbl = UILabel()
        lbl.text = currentSong.artist
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    lazy var lblSong: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.text = currentSong.name
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
    
    lazy var sldrTime: UISlider = {
        let sldr = CustomSlider(thumbRadius: 8)
        sldr.addTarget(self, action: #selector(zoomThumb(sender:)), for: .touchDown)
        return sldr
    }()
    
    lazy var sldrVolume: UISlider = {
        let sldr = CustomSlider(thumbRadius: 20)
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
        btn.addTarget(self, action: #selector(setShuffled), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnPrevious: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(previousSong), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnNext: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnPlayPause: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50)
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
        btn.addTarget(self, action: #selector(playPause), for: .touchUpInside)
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
    
    init(currentSong: Song) {
        self.currentSong = currentSong
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [imgAlbum, btnClose, lblVcTitle, lblAlbum, btnShare, lblArtist, lblSong, btnShuffle, stackSongAction, btnRepeat, sldrTime, sldrVolume, lblTimeFromStart, lblTimeToFinish, imgVolumeEmpty, imgVolumeFull].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            btnClose.widthAnchor.constraint(equalToConstant: 35),
            btnClose.heightAnchor.constraint(equalToConstant: 20),
            btnClose.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            btnClose.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            lblVcTitle.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            lblVcTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            lblAlbum.topAnchor.constraint(equalTo: lblVcTitle.bottomAnchor, constant: 3),
            lblAlbum.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            btnShare.widthAnchor.constraint(equalToConstant: 30),
            btnShare.heightAnchor.constraint(equalToConstant: 30),
            btnShare.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            btnShare.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            
            imgAlbum.trailingAnchor.constraint(equalTo: btnShare.trailingAnchor),
            imgAlbum.leadingAnchor.constraint(equalTo: btnClose.leadingAnchor),
            imgAlbum.topAnchor.constraint(equalTo: lblAlbum.bottomAnchor, constant: 15),
            imgAlbum.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
            
            lblSong.topAnchor.constraint(equalTo: imgAlbum.bottomAnchor, constant: 25),
            lblSong.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            lblArtist.topAnchor.constraint(equalTo: lblSong.bottomAnchor, constant: 5),
            lblArtist.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            lblTimeFromStart.leadingAnchor.constraint(equalTo: imgAlbum.leadingAnchor),
            lblTimeFromStart.topAnchor.constraint(equalTo: lblArtist.bottomAnchor, constant: 25),
            
            lblTimeToFinish.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            lblTimeToFinish.centerYAnchor.constraint(equalTo: lblTimeFromStart.centerYAnchor),
            
            sldrTime.topAnchor.constraint(equalTo: lblTimeFromStart.bottomAnchor, constant: 3),
            sldrTime.leadingAnchor.constraint(equalTo: imgAlbum.leadingAnchor),
            sldrTime.trailingAnchor.constraint(equalTo: imgAlbum.trailingAnchor),
            
            btnShuffle.leadingAnchor.constraint(equalTo: sldrTime.leadingAnchor),
            btnShuffle.topAnchor.constraint(equalTo: sldrTime.bottomAnchor, constant: 40),
            
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
    
    @objc func zoomThumb(sender: UISlider) {
        //
        //        sldrVolume = CustomSlider(thumbRadius: 20)
        //        sldrVolume.removeFromSuperview()
        //        view.addSubview(sldrVolume)
    }
    
    @objc func closeVC() {
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func share(_ sender: UIButton) {
        guard let image = imgAlbum.image, let url = URL(string: "http://www.github.com/kgellert/") else {
            return
        }
        let shareSheetVC = UIActivityViewController(activityItems: [image, url], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = sender
        shareSheetVC.popoverPresentationController?.sourceRect = sender.frame
        //present(shareSheetVC, animated: true)
    }
    
    @objc func setShuffled() {
        
    }
    
    @objc func previousSong() {
        
    }
    
    @objc func nextSong() {
        
    }
    
    @objc func playPause() {
        
    }
    
}
