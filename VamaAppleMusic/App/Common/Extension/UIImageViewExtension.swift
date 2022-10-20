//
//  UIImageViewExtension.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func imageFromServerURL(urlString : String) {
        self.image = UIImage(named: "placeholderMusic.jpeg")

        if let url = URL(string: urlString) {
            
            // check cached image
            if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                self.image = cachedImage
                return
            }
            
            // if not, download image from url
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let _ = error {
                    return
                }
                
                DispatchQueue.main.async {
                    guard let notnilDate = data else { return }
                    if let image = UIImage(data: notnilDate) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
