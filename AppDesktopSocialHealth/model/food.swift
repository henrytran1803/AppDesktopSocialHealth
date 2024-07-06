//
//  food.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import Foundation

struct Food: Codable {
    var id: Int
    var name: String
    var description: String
    var calorie: Double
    var protein: Double
    var fat: Double
    var carb: Double
    var sugar: Double
    var serving: Int
    var photos: [Photo]

    
    enum CodingKeys: String, CodingKey {
        case id, name, description, calorie, protein, fat, carb, sugar, serving, photos
    }
}

struct Photo: Codable {
    var id: Int
    var photoType: String
    var image: Data?
    var url: String
    var dishId: String
    
    enum CodingKeys: String, CodingKey {
        case id, photoType = "photo_type", image, url, dishId = "dish_id"
    }
}

struct FoodResponseData: Codable {
    var data: [Food]
}
