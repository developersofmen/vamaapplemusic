//
//  AlbumDetailViewModel.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import RealmSwift

/// We can use the same AlbumListViewModel
/// But we choose to write this AlbumDetailViewModel separately
/// To demostrate the concept
/// In future: If in case we have complex AlbumDetailViewController
/// So that we will have separate control over the business logics
final class AlbumDetailViewModel {
    
    // MARK: - Properties
    private let albumRepository = AlbumRepository()

    let album: Album
    
    /// Computed property to fetch the copyrightInfo from local database
    var copyrightInfo: String? {
        return albumRepository.fetchCopyrightInfo()
    }
    
    // MARK: - Init
    
    init(_album: Album) {
        album = _album
    }
}
