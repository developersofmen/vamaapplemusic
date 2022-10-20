//
//  UIViewController+Extension.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import UIKit

extension UIViewController {
    
    /// add back button on nav bar
    func addCustomBackButton() {
        let viewContainer = UIView(frame:  CGRect(x: 0, y: 0, width: 44, height: 44))
        viewContainer.backgroundColor = .clear
        let shadowView = UIView(frame:  CGRect(x: 0, y: 0, width: 44, height: 44))
        shadowView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        shadowView.layer.cornerRadius = 22
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)), for: .normal)
        button.contentHorizontalAlignment = .center
        button.tintColor = .black
        button.addTarget(self, action: #selector(actionBackNavButton), for: .touchUpInside)
        viewContainer.addSubview(shadowView)
        viewContainer.addSubview(button)
        let leftBarItem = UIBarButtonItem(customView: viewContainer)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func setupRightBarButton(btnTitle: String? = nil, btnImage: UIImage? = nil, isHidden: Bool = false ) {
        if isHidden {
            removeRightBarButton()
        } else {
            removeRightBarButton()
            addRightBarButton(btnTitle: btnTitle, btnImage: btnImage)
        }
    }
    
    //add right button on nav bar
    private func addRightBarButton(btnTitle: String? = nil, btnImage: UIImage? = nil ) {
        var arrBarButtonItem = [UIBarButtonItem]()
        let button = UIButton(type: .system)
        if btnImage != nil{
            button.setImage(btnImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)), for: .normal)
        }
        if btnTitle != "" && btnTitle != nil{
            button.setTitle(btnTitle, for: .normal)
        }
        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 44)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(actionRightNavButton), for: .touchUpInside)
        button.titleLabel?.font =  UIFont.SFProText(.bold, size: 17)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        let barBtn = UIBarButtonItem(customView: button)
        arrBarButtonItem.append(barBtn)
        navigationItem.rightBarButtonItems = arrBarButtonItem
    }
    
    private func removeRightBarButton() {
        navigationItem.rightBarButtonItems = nil
    }
    
    //MARK: action methods
    @objc
    func actionBackNavButton() {
        
    }
    
    @objc
    func actionRightNavButton(sender: UIButton) {
        
    }
}
