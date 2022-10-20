//
//  AlbumListCell.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

final class AlbumListCell: UICollectionViewCell {
    
    // MARK: Properties
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
        label.font = UIFont.SFProText(.medium, size: 12)
        label.text = ""
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = ""
        label.numberOfLines = 4
        label.font = UIFont.SFProText(.semibold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 15
        clipsToBounds = true
        setupViews()
    }
    
    // MARK: Custom Method
    
    func configure(_ result: Album?) {
        guard let result else { return }
        albumNameLabel.text = (result.name ?? "").uppercased()
        artistNameLabel.text = result.artistName ?? ""
        albumImageView.imageFromServerURL(urlString: result.artworkUrl100 ?? "")
    }
}

// MARK: Private Method

extension AlbumListCell {
    private func setupViews() {
        addSubview(albumImageView)
        addAlbumImageViewConstraint()
        addSubview(gradientView)
        addAlphaLabelViewConstraint()
        addSubview(artistNameLabel)
        addArtistNameLabelViewConstraint()
        addSubview(albumNameLabel)
        addAlbumNameLabelViewConstraint()
        applyGradient()
    }
    
    private func addAlbumImageViewConstraint() {
        albumImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addArtistNameLabelViewConstraint() {
        artistNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        artistNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        artistNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }
    
    private func addAlbumNameLabelViewConstraint() {
        albumNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        albumNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        albumNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -1).isActive = true
    }
    
    private func addAlphaLabelViewConstraint() {
        gradientView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        gradientView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func applyGradient() {
        DispatchQueue.main.async {
            self.gradientView.layer.sublayers?.filter{$0 is CAGradientLayer}.forEach{ $0.removeFromSuperlayer()
            }
            let startColor =  UIColor.black.withAlphaComponent(0.0).cgColor
            let endColor = UIColor.black.withAlphaComponent(0.75).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [startColor, endColor]
            gradientLayer.locations = [0.0,1.0]
            gradientLayer.frame = self.gradientView.bounds
            self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        }
    }
}
