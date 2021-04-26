//
//  ReviewImagesInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

struct ReviewImagesResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [ReviewImagesInfo]?
}

struct ReviewImagesInfo: Decodable{
    let reviewImage : String?
    
    enum CodingKeys:  String, CodingKey {
        case reviewImage = "restaurantImgUrl"
    }
}
