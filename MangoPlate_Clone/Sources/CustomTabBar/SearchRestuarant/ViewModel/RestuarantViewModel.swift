//
//  RestuarantViewModel.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/16.
//

import Foundation
import Alamofire


class RestuarantViewModel {
    weak var vc: SearchRestuarantViewController?
    var restuarantInfoList: [RestuarantInfo] = []

    var numOfRestuarantInfoList: Int {
        return restuarantInfoList.count
    }
    
    // MARK: 가져온 모델 데이터 망고플레이트에 적합한 UI로 변경하기
    var trimmedRestuarantInfoList: [RestuarantInfo]{
        var count = 0
        let value = restuarantInfoList.map { (info) -> RestuarantInfo in
            count += 1
            return RestuarantInfo(mainImage: info.mainImage, name: "\(count). " + info.name, location: info.location, distance: info.distance, grade: info.grade, views: info.views, reviews: info.reviews)
        }
        return value
    }
    
    func restuarantInfo(at index: Int) -> RestuarantInfo{
        return trimmedRestuarantInfoList[index]
    }
    
    // MARK: 맛집찾기 API호출 함수모음.
    func getRestuarantListAPI(filter: Int, food: [Int], price: [Int],isAvailParking: Int, long : Double, lat: Double, distance: Int) {
        var foodValue = "&food=0"
        var priceValue = "&price=-1"
        if food != [] {
            foodValue = ""
            for i in food{
                foodValue += "&food=\(i)"
            }
        }
        if price != [] {
            priceValue = ""
            for i in price{
                priceValue += "&price=\(i)"
            }
        }
        let url = Constant.BASE_URL + "/restaurants?areaName=건대/군자/광진&filter=\(filter)" + foodValue + "" + priceValue + "&parking=\(isAvailParking)&long=\(long)&lat=\(lat)&dist=\(distance)"
        print(url)
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodedURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: RestuarantSearchResponse.self) { (response) in
                switch response.result {
                case .success(let response):
                    if response.isSuccess, let result = response.result{
                        self.restuarantInfoList = result
                        DispatchQueue.main.async {
                            self.vc?.restuarantCollectionView.reloadData()
                            IndicatorView.shared.dismiss()
                        }
                        //print(result)
                    }else{
                        print(response.message)
                    }
                case .failure(let error):
                    print("서버와의 연결이 원활하지 않습니다")
                    print(error.localizedDescription)
                    //서버와의 연결이 원활하지 않습니다.
                }
            }
    }
}
