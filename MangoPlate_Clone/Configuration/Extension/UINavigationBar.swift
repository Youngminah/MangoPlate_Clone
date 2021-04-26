//
//  UINavigationBar.swift
//  EduTemplate - storyboard
//
//  Created by Zero Yoon on 2022/02/23.
//

import UIKit

extension UINavigationBar {
    // MARK: 네비게이션바를 투명하게 처리
    var isTransparent: Bool {
        get {
            return false
        } set {
            self.isTranslucent = newValue
            self.setBackgroundImage(newValue ? UIImage() : nil, for: .default)
            self.shadowImage = newValue ? UIImage() : nil
            self.backgroundColor = newValue ? .clear : nil
        }
    }
    
    func setWhiteBackgroundColor(){
        self.backgroundColor = .white
    }
}


extension UINavigationController{
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //navigationBar.frame.size.height += 10
        //navigationBar.frame.origin.y = navigationBar.frame.size.height
        navigationBar.backgroundColor = .white
    }
}
