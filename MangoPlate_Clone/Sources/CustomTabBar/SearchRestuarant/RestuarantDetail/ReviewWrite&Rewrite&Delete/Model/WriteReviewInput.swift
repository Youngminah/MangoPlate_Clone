//
//  WriteReviewInput.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/24.
//

struct WriteReviewInput: Encodable {
    var userID: Int
    var restaurantID: Int
    var reviewScore: Int
    var reviewContents: String
    var img: [ReviewImage]
    
    var toDictionary: [String: Any] {
        let imgArray = img.map { $0.toDictionary }
        let dict: [String: Any]  = ["userID": userID, "restaurantID": restaurantID, "reviewScore": reviewScore, "reviewContents": reviewContents, "img": imgArray]
        return dict
    }
}

struct ReviewImage : Encodable{
    var imgUrl: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = [ "imgUrl" : imgUrl ]
        return dict
    }
}
