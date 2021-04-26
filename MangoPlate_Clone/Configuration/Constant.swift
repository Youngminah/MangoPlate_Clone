//
//  Constant.swift
//  EduTemplate - storyboard
//
//  Created by Zero Yoon on 2022/02/23.
//

import Alamofire

struct Constant {
    static let BASE_URL = "http://54.180.95.33:3000"
    static let HEADERS: HTTPHeaders = ["x-access-token" : JwtToken.token!]
}
