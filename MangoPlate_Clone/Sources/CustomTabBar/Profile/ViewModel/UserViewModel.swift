//
//  UserViewMoel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/26.
//

import Foundation
import Alamofire


class UserViewModel {
    var userInfo: UserInfo?
    private var baseUrl = Constant.BASE_URL + "/users"
    var didFinishFetch: (() -> ())?
    
    // MARK: 맛집찾기 API호출 함수모음.
    func userInfoAPI() {
        let url = baseUrl + "/\(JwtToken.userId!)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: UserResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            self.userInfo = result
                            print("프로필 정보 불러오기 성공!!")
                            print(result)
                            self.didFinishFetch?()
                        }
                        return
                    }else{
                        print(response.message)
                        return
                    }
                case .failure(let error):
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                    //서버와의 연결이 원활하지 않습니다.
                }
            }
    }
}
