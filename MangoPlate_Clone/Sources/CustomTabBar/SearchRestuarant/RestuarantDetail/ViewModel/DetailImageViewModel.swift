//
//  DetailImageViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import Foundation
import Alamofire


class DetailImageViewModel {
    
    weak var vc: DetailRestuarantViewController?
    var detailImageInfoList: DetailImageInfo?
    var mainImageURLArray : [String] = []
    private var baseUrl = Constant.BASE_URL + "/restaurants/"
    var didFinishFetch: (() -> ())?
    
    var numOfRestuarantInfoList: Int {
        return mainImageURLArray.count
    }
    
    func imageSubString(){
        guard let list = detailImageInfoList, let imageString = list.mainImageURL else{
            return
        }
        self.mainImageURLArray = imageString.components(separatedBy:  [" "])
    }
    
    // MARK: 맛집상세조회 API호출 함수모음.
    func requestDetailImageListAPI(restaurantID: Int) {
        let url = baseUrl + "\(restaurantID)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: DetailImageResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            self.detailImageInfoList = result
                            self.imageSubString()
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
