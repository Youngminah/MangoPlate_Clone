//
//  DetailRestuarantViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/21.
//

import Foundation
import Alamofire


class DetailRestaurantViewModel {
    var detailRestaurantInfoList: DetailRestaurantInfo?
    private var baseUrl = Constant.BASE_URL + "/restaurants/"
    
    var menuList: [String] = []
    var menuPrice: [String] = []
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: 가져온 모델 데이터 망고플레이트에 적합한 UI로 변경하기
    func sliceMenuInfo(){
        guard let info =  self.detailRestaurantInfoList else {
            return
        }
        let temp = info.menu.components(separatedBy: [","])
        for data in temp{
            self.menuList.append(data.trimmingCharacters(in: .whitespaces))
        }
        self.menuPrice = info.price.components(separatedBy:  [" "])
        
    }
    
    func detailRestaurantInfo() -> DetailRestaurantInfo?{
        return detailRestaurantInfoList
    }
    
    // MARK: 맛집찾기 API호출 함수모음.
    func requestRestaurantListAPI(restaurantID: Int) {
        let url = baseUrl + "\(restaurantID)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: DetailRestaurantResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            self.detailRestaurantInfoList = result
                            self.sliceMenuInfo()
                            //print(self.detailRestaurantInfoList)
                            self.didFinishFetch?()
                        }
                        return
                    }else{
                        print("error")
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

