//
//  PreReviewsViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import Foundation
import Alamofire


class PreReviewsViewModel {
    
    var preReviewsInfoList: [PreReviewsInfo] = []
    private var baseUrl = Constant.BASE_URL + "/reviews?score=1"
    var reviewsImagePath: [[String?]] = []
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    var numOfRestuarantInfoList: Int {
        return preReviewsInfoList.count
    }
    
    func preReviewsList(at index: Int) -> PreReviewsInfo{
        return preReviewsInfoList[index]
    }
    
    func sliceImageString(index: Int){
        guard let imageStringBefore = self.preReviewsInfoList[index].reviewImage else{
            print("--> ReviewsViewModel.swift에서 이미지 뜯으려고하는데 이미지가 안들어온듯 하다")
            self.reviewsImagePath.append([nil])
            return
        }
        self.reviewsImagePath.append(imageStringBefore.components(separatedBy: " "))
    }
    
    // MARK: 맛집상세조회 API호출 함수모음.
    func requestPreReviewsListAPI() {
        let url = baseUrl
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: PreReviewsResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            //print(result)
                            self.preReviewsInfoList = result
                            for index in 0..<self.preReviewsInfoList.count{
                                self.sliceImageString(index: index)
                            }
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
