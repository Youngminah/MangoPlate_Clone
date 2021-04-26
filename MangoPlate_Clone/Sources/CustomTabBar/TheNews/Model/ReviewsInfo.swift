//
//  ReviewsInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

struct ReviewsResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [ReviewsInfo]?
}

struct ReviewsInfo: Decodable{
    let userImage: String?
    let userName: String
    let totalReviews: Int
    let follower : Int
    let satisfaction : String
    let restaurantName: String
    let location: String
    let reviewContent: String
    let likes : Int
    let comments : Int
    let date : String
    let reviewImage : String?
    
    enum CodingKeys:  String, CodingKey {
        case userImage = "userProfileImgUrl"
        case userName = "userName"
        case totalReviews = "numReview"
        case follower = "numFollower"
        case satisfaction = "reviewScore"
        case restaurantName = "restaurantName"
        case location = "restaurantArea"
        case reviewContent = "reviewContents"
        case likes = "numLikes"
        case comments = "numComments"
        case date = "date"
        case reviewImage = "restaurantImgUrl"
        
    }
}
