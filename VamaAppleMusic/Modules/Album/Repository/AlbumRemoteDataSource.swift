//
//  AlbumRemoteDataSource.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation

final class AlbumRemoteDataSource {
    
    /// fetchAlbumFeed
    /// - Parameters:
    /// - completionHandler: AlbumFeed?, AppError?
    func fetchAlbumFeed(completionHandler: @escaping ((AlbumFeed?, AppError?) -> Void)) {
        
        // Fetch the data from api call via HTTPManager
        HTTPManager.shared.getNetworkCall(strEndpoint: Constants.AppUrl.APIEndPoint.albums) { (result, error) in
            if let error {
                completionHandler(nil, error)
            }
            
            guard let result else {
                completionHandler(nil, AppError(_message: Constants.Message.unknownError))
                return
            }
            
            do {
                let responseJson = try JSONDecoder().decode(AlbumResponse.self, from: result.data)
                completionHandler(responseJson.feed, nil)
            } catch {
                completionHandler(nil, AppError(_message: Constants.Message.unknownError))
            }
        }
    }
}
