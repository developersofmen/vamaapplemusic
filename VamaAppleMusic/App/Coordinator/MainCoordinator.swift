//
//  AppCoordinator.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(_navigationController: UINavigationController) {
        navigationController = _navigationController
    }
    
    // MARK: - Start
    
    func start() {
        let albumListController = AlbumListViewController(_albumViewModel: AlbumListViewModel())
        albumListController.mainCoordinator = self
        navigationController.setViewControllers([albumListController], animated: false)
    }
    
    // MARK: Coordinate to screens
    
    func coordinateToAlbumDetail(album: Album) {
        let albumDetailsController = AlbumDetailViewController(_albumDetailViewModel: AlbumDetailViewModel(_album: album))
        albumDetailsController.mainCoordinator = self
        navigationController.pushViewController(albumDetailsController, animated: true)
    }
    
    func coordinateToOpenUrl(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func coordinateBackToAlbumList() {
        navigationController.popViewController(animated: true)
    }
}
