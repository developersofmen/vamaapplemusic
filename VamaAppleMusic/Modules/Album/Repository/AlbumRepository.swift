//
//  AlbumRepository.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import RealmSwift

final class AlbumRepository {
    
    // MARK: - Properties
    
    let localDataSource = AlbumLocalDataSource()
    let remoteDataSource = AlbumRemoteDataSource()
    
    // MARK: - Fetch Methods
    
    /// fetchAndSyncAlbums from remote datasource and sync with the local database
    /// - Parameters:
    ///   - completionHandler:
    func fetchAndSyncAlbums(completionHandler: @escaping ((AppError?) -> Void)) {
        
        // Fetch album feed data via remoteDataSource
        remoteDataSource.fetchAlbumFeed { feed, error in
            if let error {
                completionHandler(error)
            } else {
                // Sync local database with the updated data from the api response
                
                // Delete old data from local database
                self.localDataSource.deleteAlbumFeed()
                
                // Add new data coming from the api response
                if let feed {
                    self.localDataSource.addAlbumFeed(feed: feed)
                }
                completionHandler(nil)
            }
        }
    }
    
    /// Fetch albums from local database
    /// - Returns: albums list
    func fetchAlbums() -> List<Album>? {
        return localDataSource.fetchAlbums()
    }
    
    /// fetchCopyrightInfo
    /// - Returns: copyright text
    func fetchCopyrightInfo() -> String? {
        return localDataSource.fetchCopyrightInfo()
    }
}
