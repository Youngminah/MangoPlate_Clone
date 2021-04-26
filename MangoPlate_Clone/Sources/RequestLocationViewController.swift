//
//  RequestLocationViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/16.
//

import UIKit

class RequestLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func agreeLocationInfoTab(_ sender: UIButton) {
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabBar") as? CustomTabBarViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
    
    @IBAction func disagreeLocationInfoTab(_ sender: Any) {
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabBar") as? CustomTabBarViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
}
