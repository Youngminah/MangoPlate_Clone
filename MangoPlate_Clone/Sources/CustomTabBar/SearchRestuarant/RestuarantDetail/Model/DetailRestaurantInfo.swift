//
//  DetailRestuarantInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/21.
//
struct DetailRestaurantResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: DetailRestaurantInfo?
}

struct DetailRestaurantInfo: Decodable{
    let name: String
    let score: Double
    let views: Int
    let wannago: Int
    let reviews: Int
    let generalAddress: String
    let streetAddress: String
    let openTime: String
    let hoilday: String?
    let priceAverage: String
    let menu: String
    let price: String
    let total: Int
    let great: Int
    let soso: Int
    let bad: Int
    
    enum CodingKeys:  String, CodingKey {
        case name = "restaurantName"
        case score = "restaurantScore"
        case views = "restaurantView"
        case wannago = "restaurantWant"
        case reviews = "restaurantComment"
        case generalAddress = "restaurantAddress"
        case streetAddress = "restaurantAddress2"
        case openTime = "restaurantRunTime"
        case hoilday = "restaurantHoliday"
        case priceAverage = "priceRange"
        case menu = "restaurantMenu"
        case price = "restaurantPrice"
        case total = "commentTotal"
        case great = "restaurantGreat"
        case soso = "restaurantSoso"
        case bad = "restaurantBad"
    }
}
