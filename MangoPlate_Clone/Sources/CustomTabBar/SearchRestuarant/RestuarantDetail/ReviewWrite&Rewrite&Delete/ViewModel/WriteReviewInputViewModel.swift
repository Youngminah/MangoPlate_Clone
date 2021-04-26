//
//  WriteReviewInputViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/24.
//

import Alamofire


class WriteReviewInputViewModel {
    private var baseUrl = Constant.BASE_URL + "/reviews"
    var didFinishFetch: (() -> ())?
    var input : WriteReviewInput?
    var reviewImages: [ReviewImage] = []
    
    
    func appendReviewImages(imageURLString: String){
        let reviewImage = ReviewImage(imgUrl: imageURLString)
        self.reviewImages.append(reviewImage)
    }
    
    
    func setInput(restaurantID: Int, reviewScore: Int, reviewContents: String){
        self.input = WriteReviewInput(userID: JwtToken.userId!, restaurantID: restaurantID, reviewScore: reviewScore, reviewContents: reviewContents, img: reviewImages)
    }
    
    
    // MARK: 맛집상세조회 API호출 함수모음.
    func postImageListAPI() {
        let url = baseUrl
        //let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let input1 = input else {
            print("ViewModel에서 input변환안되는오륲")
            return
        }
        //print(input1.toDictionary)
        AF.request(url, method: .post, parameters: input1.toDictionary ,encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: WriteReviewReqResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        print(response)
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
