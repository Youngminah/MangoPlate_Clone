//
//  DetailImageInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

struct DetailImageResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: DetailImageInfo?
}

struct DetailImageInfo: Decodable{
    let mainImageURL: String?
    
    enum CodingKeys:  String, CodingKey {
        case mainImageURL = "imgUrl"
    }
}
