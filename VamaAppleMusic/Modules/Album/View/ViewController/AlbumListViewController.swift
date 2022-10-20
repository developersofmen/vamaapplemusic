//
//  AlbumListViewController.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit
import CoreData

final class AlbumListViewController: UIViewController {
    
    // MARK: Properties
    
    private static let albumCellIdentifier = "AlbumListCellIdentifier"
    private let albumCollectionView: UICollectionView
    private let albumViewModel: AlbumListViewModel
    private let cellPadding = 16.0
    private let cellInsetTop = 10.0
    private let cellSpacing = 12.0
    private let column = 2
    
    var mainCoordinator: MainCoordinator?
    
    private var cellWidthAndHeight: Double {
        return (UIScreen.width - (cellPadding * Double(column)) - cellSpacing) / Double(column)
    }
    
    // MARK: Init
    
    init(_albumViewModel: AlbumListViewModel) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellInsetTop, left: cellPadding, bottom: 0.0, right: cellPadding)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        
        albumCollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        albumViewModel = _albumViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // configureCollectionView
        // render the data on collectionViewCell with the local album data
        configureCollectionView()
        
        // fetch the updated album data from api
        // and save into the local database
        fetchAndSyncAlbumData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addAlbumCollectionViewConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = .systemBackground
    }
    
    /// This method is being called when user taps on refresh button
    /// - Parameter sender: sender UIButton
    override func actionRightNavButton(sender: UIButton) {
        // Refresh the data
        fetchAndSyncAlbumData()
    }
}

// MARK: Private methods

private extension AlbumListViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = Constants.Title.albumlistHeader
        
        // On launch show refresh button at right navigation bar
        // Only when there is no data available
        if !albumViewModel.isEmptyAlbumData {
            setupRightBarButton(btnTitle: Constants.Title.refreshButton)
        }
    }
    
    private func configureCollectionView(){
        setupDelegateAndDatasource()
        albumCollectionView.register(AlbumListCell.self, forCellWithReuseIdentifier: AlbumListViewController.albumCellIdentifier)
        albumCollectionView.backgroundColor = .systemBackground
        view.addSubview(albumCollectionView)
    }
    
    private func setupDelegateAndDatasource() {
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
    }
    
    private func addAlbumCollectionViewConstraint() {
        albumCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIEdgeInsets.zero.top).isActive = true
        albumCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIEdgeInsets.zero.bottom).isActive = true
    }
    
    /// fetchAndSyncAlbumData
    /// This method will make the api call
    /// Sync the updated data from api with the local database
    private func fetchAndSyncAlbumData() {
        
        // show full screen loader at the time of api call
        // only when there is no data on UI
        // if there is already data showing on the UI
        // do not show the loader at the api call.
        // Just refresh the UI with the new data
        if albumViewModel.isEmptyAlbumData {
            displayAnimatedActivityIndicatorView()
        }
        
        albumViewModel.fetchAndSyncAlbums { error in
            DispatchQueue.main.async {
                self.updateUIAfterNetworkCall()
                // if error occured, show error message
                // else update UI with latest data
                if let error {
                    // show error message
                    AppToast.show(message: error.message, controller: self, isError: true)
                } else {
                    // show no records found message when album data is empty
                    if self.albumViewModel.isEmptyAlbumData {
                        AppToast.show(message: Constants.Message.noRecord, controller: self, isError: true)
                    }
                    self.albumCollectionView.reloadData()
                }
            }
        }
    }
    
    /// This method being called after the album data api response
    /// regardless of failure or success
    /// responsbible for the hidding of the loader
    /// show the refresh button on right navigation bar
    /// show no record message if album data is empty
    private func updateUIAfterNetworkCall() {
        
        // This hides the loader if visible currently
        hideAnimatedActivityIndicatorView()
        
        setupRightBarButton(btnTitle: Constants.Title.refreshButton)
    }
}

// MARK: UICollectionViewDataSource

extension AlbumListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albums = albumViewModel.albums else { return 0 }
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get the cell with the withReuseIdentifier
        // instead of force upwrap to as! AlbumListCell
        // we are still fetching the option AlbumListCell
        // to follow the strict rules to avoid force unwrapping

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListViewController.albumCellIdentifier, for: indexPath) as? AlbumListCell
        
        // unwrap AlbumListCell safely
        guard let cell else {
            // if in any case cell is nil
            // return the cell without converting to AlbumListCell
            return collectionView.dequeueReusableCell(withReuseIdentifier: AlbumListViewController.albumCellIdentifier, for: indexPath)
        }
        
        guard let albums = albumViewModel.albums else { return cell }
        cell.configure(albums[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension AlbumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
}

// MARK: UICollectionViewDelegate

extension AlbumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albums = albumViewModel.albums else { return }
        mainCoordinator?.coordinateToAlbumDetail(album: albums[indexPath.row])
    }
}

