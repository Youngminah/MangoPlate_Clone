//
//  RestuarantInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/16.
//

struct RestuarantSearchResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [RestuarantInfo]?
}

struct RestuarantInfo: Decodable{
    let mainImage: String?
    let name: String
    let location: String
    let distance: String
    let grade: Double
    let views: Int
    let reviews: Int
    
    enum CodingKeys:  String, CodingKey {
        case mainImage = "restaurantMenuImg"
        case name = "restaurantName"
        case location = "restaurantArea"
        case distance = "dist"
        case grade = "restaurantScore"
        case views = "restaurantView"
        case reviews = "restaurantComment"
    }
}
