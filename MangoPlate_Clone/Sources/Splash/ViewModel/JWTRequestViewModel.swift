//
//  JWTRequestViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

import Alamofire


class JWTRequestViewModel {
    
    var accessKey : KakaoAccessKey!
    var didFinishFetch: (() -> ())?
    
    func accessTokenSave(key: String) {
        self.accessKey = KakaoAccessKey(accessToken: key)
    }
    // MARK: 소셜로그인 API호출 함수.
    func getJwtAPI() {
        let url = Constant.BASE_URL + "/kakao-login"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let key = accessKey else {
            return
        }
        AF.request(encodedURL, method: .post, parameters: key, headers: nil)
            .validate()
            .responseDecodable(of: JWTRequestResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            JwtToken.token = result.jwt
                            JwtToken.userId = result.userId
                            print("jwt토큰이 제대로 들어왔나?-> " + "\(JwtToken.token)")
                            print("유저아이디가 제대로 들어왔나?-> " + "\(result.userId)")
                            UserDefaults.standard.set(JwtToken.token, forKey: "JwtToken")
                            UserDefaults.standard.set(result.userId, forKey: "UserId")
                            self.didFinishFetch?()
                        }
                    }else{
                        print(response.message + "<-JWTViewModel이다")
                    }
                case .failure(let error):
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                    //서버와의 연결이 원활하지 않습니다.
                }
            }
    }
}
