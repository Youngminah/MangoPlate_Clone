//
//  DeleteReviewViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

import Alamofire


class DeleteReviewViewModel {
    private var baseUrl = Constant.BASE_URL + "/reviews"
    var didFinishFetch: (() -> ())?
    
    // MARK: 맛집상세조회 API호출 함수모음.
    func deleteReviewAPI(reviewId: Int) {
        let url = baseUrl + "/\(reviewId)/status"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodedURL, method: .patch, parameters: nil, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: DeleteReviewResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        print(response.message)
                        DispatchQueue.main.async {
                            self.didFinishFetch?()
                        }
                        return
                    }else{
                        print("error\(response)")
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
