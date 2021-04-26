//
//  SplashViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/14.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class SplashViewController: BaseViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    
    var jwtRequestViewModel = JWTRequestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoKakaoLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initiateUIButton()
    }
    
    func initiateUIButton(){
        self.facebookLoginButton.cornerRadiusLogin()
        self.kakaoLoginButton.cornerRadiusLogin()
    }
    
    @IBAction func kakaoLoginRequestButtonTab(_ sender: UIButton) {
        // MARK: 소셜로그인요청 클로져로 보냄
        self.requestKakaoLogin()
    }
    
    @IBAction func presentMainStoryboard(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestLocationView") as? RequestLocationViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension SplashViewController{
    
    func autoKakaoLogin(){
        if let key = UserDefaults.standard.string(forKey: "JwtToken") {
            JwtToken.token = key
            JwtToken.userId = UserDefaults.standard.integer(forKey: "UserId")
            JwtToken.isLogin = true
            print(JwtToken.token)
            DispatchQueue.main.async {
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestLocationView") as? RequestLocationViewController else{
                    return
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        //print(UserDefaults.standard.string(forKey: "JwtToken"))
    }
    
    
    // MARK: 카카오 로그인 할 때 호출되는 함수
    func requestKakaoLogin(){
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error { print(error) }
                else {
                    //do something
                    guard let tokenInfo = oauthToken else{
                        return
                    }
                    print("여기주목!!")
                    print(tokenInfo.accessToken)
                    self.jwtRequestViewModel.accessTokenSave(key: tokenInfo.accessToken)
                    self.jwtRequestViewModel.getJwtAPI()
                    self.jwtRequestViewModel.didFinishFetch = {
                        JwtToken.isLogin = true
                        self.successLogin()
                    }
                }
            }
    }
    
    // MARK: 카카오 로그인이 성공했다면 , RootViewController를 바꾸면서 화면 이동하기
    func successLogin(){
        print("loginWithKakaoAccount() success.")
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestLocationView") as? RequestLocationViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
