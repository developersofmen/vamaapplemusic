//
//  Coordinator.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 17/10/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
