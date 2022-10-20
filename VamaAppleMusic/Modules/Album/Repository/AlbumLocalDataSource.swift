//
//  AlbumLocalDataSource.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import RealmSwift

final class AlbumLocalDataSource {
    
    /// addAlbumFeed
    /// - Parameter feed: feed
    func addAlbumFeed(feed: AlbumFeed) {
        RealmManager.addObject(feed)
    }
    
    /// fetchAlbums from DB-> AlbumFeed-> Album
    /// - Returns: Album
    func fetchAlbums() -> List<Album>? {
        let feeds = fetchAlbumFeed()
        guard let feed = feeds?.first else { return nil }
        return feed.albums
    }
    
    /// fetchCopyrightInfo from DB-> AlbumFeed
    /// - Returns: copyright string
    func fetchCopyrightInfo() -> String? {
        let feeds = fetchAlbumFeed()
        guard let feed = feeds?.first else { return nil }
        return feed.copyright
    }
    
    /// delete all AlbumFeed data
    func deleteAlbumFeed() {
        RealmManager.deleteAllObjects(AlbumFeed.self)
    }
    
    /// fetchAlbumFeed
    /// - Returns: AlbumFeed
    private func fetchAlbumFeed() -> Results<AlbumFeed>? {
        return RealmManager.getObjects(AlbumFeed.self)
    }
}
