//
//  login.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 5/7/24.
//

import Foundation
struct Login_model:Codable {
    var email :String
    var password :String
}
struct ResponseData: Codable {
    var id: Int
    var role:Int 
    var token: String
}

struct ResponseModel: Codable {
    var status: String
    var message: String
    var data: ResponseData
}
