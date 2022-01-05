//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Кирилл  Геллерт on 26.12.2021.
//

import UIKit

class MusicListViewController: UIViewController {
    
    let songs: [Song] = Song.getSongList()
    
    var lblVCTitle: UILabel = {
        let lbl = UILabel()
        let attributesVCTitle: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .regular),
            .foregroundColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        ]
        lbl.attributedText = NSAttributedString(string: "Plist", attributes: attributesVCTitle)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(lblVCTitle)
        NSLayoutConstraint.activate([
            lblVCTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            lblVCTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        for index in songs.indices {
            let imgAlbum = createAlbumImgView(index: index)
            let lblSong = createSongLbl(index: index)
            let lblArtist = createArtistLbl(index: index)
            let lblDuration = createDurationLbl(index: index)
            let viewLine = createLineView(index: index)
            
            NSLayoutConstraint.activate([
                imgAlbum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                imgAlbum.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(80 * (index + 1))),
                imgAlbum.widthAnchor.constraint(equalToConstant: 60),
                imgAlbum.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            NSLayoutConstraint.activate([
                lblSong.leadingAnchor.constraint(equalTo: imgAlbum.trailingAnchor, constant: 15),
                lblSong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
                lblSong.topAnchor.constraint(equalTo: imgAlbum.topAnchor, constant: 10)
            ])
            
            NSLayoutConstraint.activate([
                lblDuration.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                lblDuration.centerYAnchor.constraint(equalTo: imgAlbum.centerYAnchor)
            ])
            
            NSLayoutConstraint.activate([
                lblArtist.leadingAnchor.constraint(equalTo: imgAlbum.trailingAnchor, constant: 15),
                lblArtist.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
                lblArtist.bottomAnchor.constraint(equalTo: imgAlbum.bottomAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                viewLine.topAnchor.constraint(equalTo: imgAlbum.bottomAnchor, constant: 10),
                viewLine.heightAnchor.constraint(equalToConstant: CGFloat(1)),
                viewLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                viewLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }
    }
    
    func createAlbumImgView(index: Int) -> UIImageView {
        let imgAlbum = UIImageView()
        imgAlbum.image = UIImage(data: songs[index].albumImageData ?? Data()) ?? UIImage(named: "EmptyAlbum")
        setupView(curView: imgAlbum, index: index)
        return imgAlbum
    }
    
    func createSongLbl(index: Int) -> UILabel {
        let lblSong = UILabel()
        lblSong.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lblSong.text = songs[index].name
        setupView(curView: lblSong, index: index)
        return lblSong
    }
    
    func createArtistLbl(index: Int) -> UILabel {
        let lblArtist = UILabel()
        let attributesArtist: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ]
        lblArtist.attributedText = NSAttributedString(string: songs[index].artist, attributes: attributesArtist)
        setupView(curView: lblArtist, index: index)
        return lblArtist
    }
    
    func createDurationLbl(index: Int) -> UILabel {
        let lblDuration = UILabel()
        lblDuration.text = songs[index].duration
        setupView(curView: lblDuration, index: index)
        return lblDuration
    }
    
    func createLineView(index: Int) -> UIView {
        let viewLine = UIView()
        viewLine.backgroundColor = .lightGray
        setupView(curView: viewLine, index: index)
        return viewLine
    }
    
    func setupView(curView: UIView, index: Int) {
        view.addSubview(curView)
        curView.translatesAutoresizingMaskIntoConstraints = false
        curView.tag = index
        let tapGesturizer = UITapGestureRecognizer(target: self, action: #selector(tapOnSong(target:)))
        curView.addGestureRecognizer(tapGesturizer)
        curView.isUserInteractionEnabled = true
    }
    
    @objc func tapOnSong(target: UITapGestureRecognizer) {
        guard let indexView = target.view?.tag else {return}
        let playerVC = PlayerViewController(currentSong: songs[indexView])
        present(playerVC, animated: true, completion: nil)
    }

}
