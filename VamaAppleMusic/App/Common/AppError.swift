//
//  AppError.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation

struct AppError {
    
    // MARK: Properties
    
    var message: String
    var code: Int?
    
    // MARK: Init
    
    /// init
    ///
    /// - Parameters:
    ///   - msg: error message
    ///   - code: error code
    init(_message: String, _code: Int? = nil) {
        message = _message
        code = _code
    }
}
