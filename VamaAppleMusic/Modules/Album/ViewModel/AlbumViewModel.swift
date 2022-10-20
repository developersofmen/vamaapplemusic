//
//  AlbumViewModel.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation
import RealmSwift

struct AlbumViewModel {
    
    // MARK: - Properties
    
    private let albumRepository = AlbumRepository()
    
    var albums: List<Album>? {
        return albumRepository.fetchAlbums()
    }
    
    var copyrightInfo: String? {
        return albumRepository.fetchCopyrightInfo()
    }
    
    // MARK: Custom methods
    
    /// fetchAndSyncAlbums data from database
    /// - Parameters:
    ///   - success: success completion, return album manage contex object
    ///   - failure: failure completion, return error message
    func fetchAndSyncAlbums(success: @escaping (() -> Void), failure: @escaping ((String) -> Void)) {
        let internetAvailable = Reachability.isConnectedToNetwork()
        if internetAvailable {
            albumRepository.fetchAndSyncAlbums {
                success()
            } failure: { errorMessage in
                failure(errorMessage)
            }
        } else {
            failure(Constants.Message.connectionLost)
        }
    }
}
