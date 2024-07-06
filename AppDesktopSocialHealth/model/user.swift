//
//  user.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import Foundation

struct User: Codable {
    var email: String
    var firstname: String
    var lastname: String
    var role: Int
    var height: Double
    var weight: Double
    var bdf: Double
    var tdee: Double
    var calorie: Double
    var id: Int
    var status: Int
    var createdAt: String
    var updatedAt: String
    var deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case email, firstname, lastname, role, height, weight, bdf, tdee, calorie, id, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct UserResponseData: Codable {
    var data: [User]
}
struct UserCreate:Codable {
    var email: String
    var firstname: String
    var lastname: String
    var role: Int
    var height: Double
    var weight: Double
    var bdf: Double
    var tdee: Double
    var calorie: Double
   
    var status: Int
}
struct UserUpdate:Codable {
    var id: Int
    var email: String
    var firstname: String
    var lastname: String
    var role: Int
    var height: Double
    var weight: Double
    var bdf: Double
    var tdee: Double
    var calorie: Double
    var status: Int
}
