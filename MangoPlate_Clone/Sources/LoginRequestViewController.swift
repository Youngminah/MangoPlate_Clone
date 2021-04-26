//
//  LoginRequestViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/15.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


class LoginRequestViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.facebookLoginButton.cornerRadiusLogin()
        self.kakaoLoginButton.cornerRadiusLogin()
    }
    
    @IBAction func closeWindowButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func kakaoLoginRequestTab(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CustomTabBar") as? CustomTabBarViewController else{
                        return
                    }
                    self.changeRootViewController(mainTabBarController)
                    //do something
                    _ = oauthToken
                }
            }
    }
}
