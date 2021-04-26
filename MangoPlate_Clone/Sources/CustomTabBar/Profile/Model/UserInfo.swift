//
//  UserInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/26.
//

struct UserResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: UserInfo?
}

struct UserInfo: Decodable{
    let userID: Int
    let userName: String
    let userImage: String
    let wanngo : Int
    let visited : Int
    let myList: Int
    let photos: Int
    let reviews: Int
    let following : Int
    let follower : Int
    
    enum CodingKeys:  String, CodingKey {
        case userID = "userID"
        case userName = "userName"
        case userImage = "userProfileImgUrl"
        case wanngo = "numWant"
        case visited = "numVisited"
        case myList = "numMyList"
        case photos = "numImg"
        case reviews = "numReview"
        case following = "numFollowing"
        case follower = "numFollower"
    }
}
