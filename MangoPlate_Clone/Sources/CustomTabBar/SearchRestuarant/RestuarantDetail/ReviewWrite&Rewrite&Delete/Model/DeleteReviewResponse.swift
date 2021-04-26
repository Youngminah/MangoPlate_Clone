//
//  DeleteReviewResponse.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/25.
//

struct DeleteReviewResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
