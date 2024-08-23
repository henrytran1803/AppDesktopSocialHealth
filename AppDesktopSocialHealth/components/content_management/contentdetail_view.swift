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
                CustomText(text: .constant("\(post.id)"), placeholder:"ID" )
                Spacer()
            }
            HStack {
                CustomText(text: .constant("\(post.title)"), placeholder:"Title" )
            }
            HStack {
                
                CustomText(text: .constant("\(post.body)"), placeholder:"Body" )
                Spacer()
            }
            HStack {
                CustomText(text: .constant("\(post.count_likes)"), placeholder:"Count likes" )
                CustomText(text: .constant("\(post.count_comments)"), placeholder:"Count comment" )
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
            .padding()
    }
}

