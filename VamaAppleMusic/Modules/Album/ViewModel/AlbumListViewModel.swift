//
//  AlbumListViewModel.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation
import RealmSwift

class AlbumListViewModel {
    
    // MARK: - Properties
    
    private let albumRepository = AlbumRepository()
    
    /// Computed property to fetch the updated album data from local database
    var albums: List<Album>? {
        return albumRepository.fetchAlbums()
    }

    /// isEmptyAlbumData computed property
    /// Return:
    /// - true When Album model is nil or does not have any data
    /// - false when Album exists and has data
    var isEmptyAlbumData: Bool {
        if (albums == nil) || (albums?.isEmpty == true) {
            return true
        }
        return false
    }
    
    // MARK: Custom methods
    
    /// fetchAndSyncAlbums data from the repository
    /// - Parameters:
    ///   - completionHandler: success if AppError is nil
    func fetchAndSyncAlbums(completionHandler: @escaping ((AppError?) -> Void)) {
        if Reachability.isConnectedToNetwork() {
            albumRepository.fetchAndSyncAlbums { error in
                completionHandler(error)
            }
        } else {
            completionHandler(AppError(_message: Constants.Message.connectionLost))
        }
    }
}
