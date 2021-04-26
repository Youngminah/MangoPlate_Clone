//
//  BaseViewController.swift
//  EduTemplate - storyboard
//
//  Created by Zero Yoon on 2022/02/23.
//

import UIKit



class BaseViewController: UIViewController {
    
    typealias QueryValue = (filter: Int, distance: Int)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: 아래 예시들처럼 상황에 맞게 활용하시면 됩니다.
        // Navigation Bar
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            .font : UIFont.NotoSans(.medium, size: 16),
//        ]
        // Background Color
//        self.view.backgroundColor = .white
    }
}



