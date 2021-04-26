//
//  DetailReviewsInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//


struct PreReviewsResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [PreReviewsInfo]?
}

struct PreReviewsInfo: Decodable{
    let reviewId: Int
    let userImage: String
    let id: String
    let totalReviews : Int
    let follower : Int
    let satisfaction: String
    let reviewContent: String
    let likes : Int
    let comments : Int
    let date : String
    let reviewImage: String?
    
    enum CodingKeys:  String, CodingKey {
        case reviewId = "reviewID"
        case userImage = "userProfileImgUrl"
        case id = "userName"
        case totalReviews = "numReview"
        case follower = "numFollower"
        case satisfaction = "reviewScore"
        case reviewContent = "reviewContents"
        case likes = "numLikes"
        case comments = "numComments"
        case date = "date"
        case reviewImage = "restaurantImgUrl"
    }
}
