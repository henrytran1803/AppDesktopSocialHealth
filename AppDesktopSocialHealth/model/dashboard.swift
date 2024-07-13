//
//  dashboard.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 13/7/24.
//

import Foundation

struct UserActive: Codable {
    var id_user: String
    var last_login: Date
    
    enum CodingKeys: String, CodingKey {
        case id_user
        case last_login
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_user = try container.decode(String.self, forKey: .id_user)
        
        let dateString = try container.decode(String.self, forKey: .last_login)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .last_login, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        last_login = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id_user, forKey: .id_user)
        
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: last_login)
        try container.encode(dateString, forKey: .last_login)
    }
}

struct DashBoard: Codable {
    var all_user: Int
    var user_disable: Int
    var count_posts: Int
    var count_food: Int
    var count_exersice: Int
    var count_photos: Int
    var active_user: Int
    var list_active: [UserActive]?
    
    enum CodingKeys: String, CodingKey {
        case all_user
        case user_disable
        case count_posts
        case count_food
        case count_exersice
        case count_photos
        case active_user
        case list_active
    }
}
