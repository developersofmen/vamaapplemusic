//
//  Constant.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation
import UIKit

struct Constants {
    struct AppUrl {
        static let BaseURL = "https://rss.applemarketingtools.com/api/v2/"
        struct APIEndPoint {
            static let albums = "us/music/most-played/100/albums.json"
        }
    }
    
    struct Message {
        static let unknownError = "Something went wrong, please try again."
        static let unknownUrl = "Requested resource url is not available."
        static let connectionLost = "You seem offline, Please check your network connectivity."
        static let noInternet = "Please check your network connectivity and try again."
        static let requestTimeOut = "Request time out, please try again."
        static let noRecord = "No records found"
    }
    
    struct Title {
        static let albumlistHeader = "Top 100 Albums"
        static let refreshButton = "Refresh"
        static let visitTheAlbum = "Visit The Album"
        static let copyright = "Copyright"
        static let released = "Released "
    }
}
