//
//  post.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 11/7/24.
//

import Foundation

struct Post:Codable {
    var id: Int
    var title : String
    var body : String
    var user_id : Int
    var count_likes :Int
    var count_comments : Int
    var photos : [PhotoPost]
}
struct PhotoPost: Codable {
    var id: Int
    var photoType: String
    var image: Data?
    var url: String
    var postId: String
    enum CodingKeys: String, CodingKey {
        case id, photoType = "photo_type", image, url, postId = "post_id"
    }
}


struct PostResponseData: Codable {
    var data: [Post]
}
