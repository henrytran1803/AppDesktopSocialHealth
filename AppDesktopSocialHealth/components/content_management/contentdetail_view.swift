//
//  contentdetail_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 11/7/24.
//

import SwiftUI

struct contentdetail_view: View {
    @State var post: Post
    @Binding var sureTodelete: Bool
    @Binding var isDetail :Bool
    var body: some View {
        
        VStack{
            HStack {
                
                
                
                
                Text("ID")
                Text("\(post.id)")
                Text("ID")
                Text("\(post.user_id)")
                Spacer()
                
            }
            HStack {
                Text("ID")
                Text(post.title)
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            HStack {
                Text("ID")
                Text(post.body)
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
            HStack {
                Text("\(post.count_likes)")
                Text("ID")
                Text("\(post.count_comments)")
                Spacer()
            }
           
            
            HStack{
                HStack {
                    ForEach(post.photos, id: \.id) { photo in
                       VStack {
                           
                           if let imageData = photo.image, let nsImage = NSImage(data: imageData) {
                               Image(nsImage: nsImage)
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 100)
                           } else {
                               Text("Invalid image data")
                           }
                       }
                    }
                }
                Spacer()
            }
            
            HStack {
                
                PrimaryButton(action: {
                    sureTodelete = true
                }, title: "DELETE")
                .padding()
                SecondaryButton(action: {
                    isDetail = false
                }, title: "CANCEL")
                .padding()
            }
        }.foregroundColor( .black)
    }
}

