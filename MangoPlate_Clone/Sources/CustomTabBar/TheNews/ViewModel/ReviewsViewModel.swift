//
//  ReviewsViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import Foundation
import Alamofire


class ReviewsViewModel {
    var reviewsInfoList: [ReviewsInfo] = []
    private var baseUrl = Constant.BASE_URL + "/reviews?"
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    //var reviewsImagePath : [[String?]] = []
    
    func detailRestaurantInfo() -> [ReviewsInfo]{
        return reviewsInfoList
    }
    
    func reset(){
        self.reviewsInfoList = []
    }
    
    var numOfReviewsInfoList: Int {
        return reviewsInfoList.count
    }
    
    func reviewsInfo(at index: Int) -> ReviewsInfo{
        return reviewsInfoList[index]
    }
    
    // MARK: 맛집찾기 API호출 함수모음.
    func requestReviewsListAPI(score: Int) {
        let url = baseUrl + "score=\(score)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            self.reviewsInfoList = result
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
