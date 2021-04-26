//
//  ReviewImagesViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

import Foundation
import Alamofire


class ReviewImagesViewModel {
    var reviewsInfoList: [ReviewImagesInfo] = []
    private var baseUrl = Constant.BASE_URL + "/reviews?"
    var didFinishFetch: (() -> ())?
    var reviewsImagePath : [[String?]] = []
    
    func sliceImageString(index: Int){
        guard let imageStringBefore = self.reviewsInfoList[index].reviewImage else{
            print("--> ReviewsViewModel.swift에서 이미지 뜯으려고하는데 이미지가 안들어온듯 하다")
            self.reviewsImagePath.append([nil])
            return
        }
        self.reviewsImagePath.append(imageStringBefore.components(separatedBy: " "))
    }

    func numOfImageInfoList(index: Int) -> Int {
        return reviewsImagePath[index].count
    }
    
    
    func reset(){
        self.reviewsInfoList = []
        self.reviewsImagePath = []
    }
    
    // MARK: 맛집찾기 API호출 함수모음.
    func requestReviewImagesListAPI(score: Int) {
        let url = baseUrl + "score=\(score)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: ReviewImagesResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        DispatchQueue.main.async {
                            self.reviewsInfoList = result
                            print("주목!!")
                            print(result)
                            for index in 0..<self.reviewsInfoList.count{
                                self.sliceImageString(index: index)
                            }
                            //print(self.reviewsImagePath)
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
