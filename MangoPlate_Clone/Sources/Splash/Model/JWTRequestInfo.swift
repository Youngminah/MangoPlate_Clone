//
//  JWTRequestInfo.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

struct JWTRequestResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: JWTRequestInfo?
}


struct JWTRequestInfo: Decodable{
    var userId: Int
    var jwt: String
}
