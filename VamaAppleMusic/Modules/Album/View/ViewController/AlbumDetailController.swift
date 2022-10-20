//
//  AlbumDetailController.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

final class AlbumDetailController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: Properties
    
    var mainCoordinator: MainCoordinator?
    var album: Album?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let albumImageViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let albumDetailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProText(.regular, size: 18)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.init(red: 142/255.0, green: 142/255.0, blue: 147/255.0, alpha: 1.0)
        return label
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 5
        label.minimumScaleFactor = 0.4
        label.font = UIFont.SFProText(.bold, size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let visitAlbumButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.SFProText(.semibold, size: 16)
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitle("Visit The Album", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)

        return button
    }()

    let copyRightInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.SFProText(.medium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
        return label
    }()
    
    let releasedInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.SFProText(.medium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
        return label
    }()
    
    let genreContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        return view
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.SFProText(.medium, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        return label
    }()
    
    // MARK: Init
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func actionBackNavButton() {
        mainCoordinator?.coordinateBackToAlbumList()
    }
    
    // MARK: Custom methods
    
    @objc
    func onClickAppStoreVisitBtn(_ sender : UIButton) {
        guard let url = URL(string: album?.artistUrl ?? "") else { return }
        mainCoordinator?.coordinateToOpenUrl(url: url)
    }
}

// MARK: Private method

extension AlbumDetailController {
    private func setupView() {
        addCustomBackButton()
        enableSwipeToPop()

        view.addSubview(containerView)
        containerView.addSubview(albumImageViewContainerView)
        containerView.addSubview(albumDetailContainerView)
        
        albumImageViewContainerView.addSubview(albumImageView)
        
        albumDetailContainerView.addSubview(artistNameLabel)
        albumDetailContainerView.addSubview(albumNameLabel)
        albumDetailContainerView.addSubview(genreContainerView)
        
        genreContainerView.addSubview(genreLabel)
        
        albumDetailContainerView.addSubview(visitAlbumButton)
        albumDetailContainerView.addSubview(copyRightInfoLabel)
        albumDetailContainerView.addSubview(releasedInfoLabel)
        
        handleConstraints()
        setData()
    }
    
    private func setData() {
        if let _albumDetails = album {
            
            var imagePath = _albumDetails.artworkUrl100 ?? ""
            
            let internetAvailable = Reachability.isConnectedToNetwork()
            if internetAvailable {
                imagePath = _albumDetails.artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600") ?? ""
            }
            
            albumImageView.imageFromServerURL(urlString: imagePath)
            
            albumNameLabel.text = _albumDetails.name
            artistNameLabel.text = _albumDetails.artistName
            
            copyRightInfoLabel.text = "Copyright"
            
            let releaseDate = getDate(dateString: _albumDetails.releaseDate, thisFormat: "yyyy-MM-dd")
            let releaseDateString = toLocalStringWithFormat(date: releaseDate, dateFormat: "MMM dd, yyyy")
            
            releasedInfoLabel.text =  "Released " + releaseDateString
            
            genreLabel.text = _albumDetails.genres[0].name
            
            visitAlbumButton.addTarget(self, action: #selector(AlbumDetailController.onClickAppStoreVisitBtn(_:)), for: .touchUpInside)
        }
    }
    
    private func getDate(dateString: String?, thisFormat: String) -> Date
    {
        guard let notNilDate = dateString else { return Date()}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = thisFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        if let date = dateFormatter.date(from: notNilDate) as NSDate? {
            return date as Date
        } else {
            return Date()
        }
    }
    
    private func toLocalStringWithFormat(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    private func enableSwipeToPop() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: UI Constraint Methods

extension AlbumDetailController {
    private func addContainerViewConstraint() {
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addAlbumImageViewContainerViewConstraint() {
        albumImageViewContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        albumImageViewContainerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        albumImageViewContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        albumImageViewContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    private func addAlbumDetailContainerViewConstraint() {
        albumDetailContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        albumDetailContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        albumDetailContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        albumDetailContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        albumDetailContainerView.topAnchor.constraint(equalTo: albumImageViewContainerView.bottomAnchor, constant: -1).isActive = true
    }
    
    private func addAlbumImageViewConstraint() {
        albumImageView.leftAnchor.constraint(equalTo: albumImageViewContainerView.leftAnchor).isActive = true
        albumImageView.rightAnchor.constraint(equalTo: albumImageViewContainerView.rightAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: albumImageViewContainerView.topAnchor).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: albumImageViewContainerView.bottomAnchor).isActive = true
    }
    
    private func addArtistNameLabelConstraint() {
        artistNameLabel.leftAnchor.constraint(equalTo: albumDetailContainerView.leftAnchor, constant: 16).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: albumDetailContainerView.topAnchor, constant: 12).isActive = true
        artistNameLabel.rightAnchor.constraint(equalTo: albumDetailContainerView.rightAnchor, constant: -16).isActive = true
    }
    
    private func addAlbumNameLabelConstraint() {
        albumNameLabel.leftAnchor.constraint(equalTo: albumDetailContainerView.leftAnchor, constant: 14).isActive = true
        albumNameLabel.rightAnchor.constraint(equalTo: albumDetailContainerView.rightAnchor, constant: -16).isActive = true
        albumNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: -1).isActive = true
    }
    
    private func addGenreContainerViewConstraint() {
        genreContainerView.leftAnchor.constraint(equalTo: albumDetailContainerView.leftAnchor, constant: 16).isActive = true
        genreContainerView.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func addGenreLabelConstraint() {
        genreLabel.leftAnchor.constraint(equalTo: genreContainerView.leftAnchor, constant: 8).isActive = true
        genreLabel.rightAnchor.constraint(equalTo: genreContainerView.rightAnchor, constant: -8).isActive = true
        genreLabel.topAnchor.constraint(equalTo: genreContainerView.topAnchor, constant: 3).isActive = true
        genreLabel.bottomAnchor.constraint(equalTo: genreContainerView.bottomAnchor, constant: -4).isActive = true
    }
    
    private func addVisitAlbumButtonConstraint() {
        visitAlbumButton.bottomAnchor.constraint(equalTo: albumDetailContainerView.bottomAnchor, constant: -45).isActive = true
        visitAlbumButton.heightAnchor.constraint(equalToConstant: 45.5).isActive = true
        visitAlbumButton.widthAnchor.constraint(equalToConstant: 155.0).isActive = true
        visitAlbumButton.centerXAnchor.constraint(equalTo: albumDetailContainerView.centerXAnchor).isActive = true
    }
    
    private func addCopyRightInfoLabelConstraint() {
        copyRightInfoLabel.leftAnchor.constraint(equalTo: albumDetailContainerView.leftAnchor, constant: 16).isActive = true
        copyRightInfoLabel.rightAnchor.constraint(equalTo: albumDetailContainerView.rightAnchor, constant: -16).isActive = true
        copyRightInfoLabel.bottomAnchor.constraint(equalTo: visitAlbumButton.topAnchor, constant: -20).isActive = true
    }
    
    private func addReleasedInfoLabelConstraint() {
        releasedInfoLabel.leftAnchor.constraint(equalTo: albumDetailContainerView.leftAnchor, constant: 16).isActive = true
        releasedInfoLabel.rightAnchor.constraint(equalTo: albumDetailContainerView.rightAnchor, constant: -16).isActive = true
        releasedInfoLabel.bottomAnchor.constraint(equalTo: copyRightInfoLabel.topAnchor, constant: -5).isActive = true
    }
    
    func handleConstraints() {
        addContainerViewConstraint()
        addAlbumImageViewContainerViewConstraint()
        addAlbumDetailContainerViewConstraint()
        addAlbumImageViewConstraint()
        addArtistNameLabelConstraint()
        addAlbumNameLabelConstraint()
        addGenreContainerViewConstraint()
        addGenreLabelConstraint()
        addVisitAlbumButtonConstraint()
        addCopyRightInfoLabelConstraint()
        addReleasedInfoLabelConstraint()
    }
}
