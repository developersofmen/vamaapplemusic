//
//  Album.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation
import RealmSwift

class AlbumResponse: Object, Codable {
    @Persisted var feed: AlbumFeed?
}

class AlbumFeed: Object, Codable {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var title: String?
    @Persisted var copyright: String?
    @Persisted var icon: String?
    @Persisted var updated: String?
    @Persisted var country: String?
    @Persisted var author: Author?
    @Persisted var albums = List<Album>()
    @Persisted var links = List<Link>()
    
    private enum CodingKeys : String, CodingKey {
        case id, title, copyright, icon, updated, country, author, albums = "results", links
    }
}

class Album: Object, Codable {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var artistId: String?
    @Persisted var artistName: String?
    @Persisted var artistUrl: String?
    @Persisted var artworkUrl100: String?
    @Persisted var contentAdvisoryRating: String?
    @Persisted var kind: String?
    @Persisted var name: String?
    @Persisted var releaseDate: String?
    @Persisted var url: String?
    @Persisted var genres = List<Genre>()
}

class Author: Object, Codable {
    @Persisted var name: String?
    @Persisted var url: String?
}

class Link: Object, Codable {
    @Persisted var linkString: String?
    
    private enum CodingKeys : String, CodingKey {
        case linkString = "self"
    }
}

class Genre: Object, Codable {
    @Persisted var genreId: String?
    @Persisted var name: String?
    @Persisted var url: String?
}

