//
//  UIScreen.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import UIKit

extension UIScreen {
    static var width : CGFloat {
        return min(UIScreen.main.bounds.height,UIScreen.main.bounds.width)
    }
    
    static var height : CGFloat {
        return max(UIScreen.main.bounds.height,UIScreen.main.bounds.width)
    }
}

