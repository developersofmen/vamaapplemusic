//
//  UIFont+Extention.swift
//  SampleMusicApp
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

extension UIFont {
    public enum SFProTextType: String {
        case semibold   = "SFProText-Semibold"
        case regular    = "SFProText-Regular"
        case bold       = "SFProText-Bold"
        case medium     = "SFProText-Medium"
    }

    static func SFProText(_ type: SFProTextType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

