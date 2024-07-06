//
//  SideMenu.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import SwiftUI

struct SideMenu: View {
    @Binding var currentTab: String
    @Namespace var animation
    @Binding var isLogin : Bool
    var body: some View {
        VStack{
            HStack{
                Text("Health")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .kerning(1.5)
                Text("Fit")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .kerning(1.5)
                    .padding(8)
                    .background(Color.primaryy)
                    .cornerRadius(8)
            }
            .padding(10)
            Divider()
                .background(Color.gray.opacity(0.4))
                .padding(.bottom)
            Text("Welcome Admin!")
                .font(.title2)
                .bold()
                .foregroundStyle(.secondary)
            VStack{
                TabButton(image: "home", title: "Home", animation: animation, currentTab: $currentTab)
                TabButton(image: "account", title: "Accounts", animation: animation, currentTab: $currentTab)
                TabButton(image: "food", title: "Foods", animation: animation, currentTab: $currentTab)
                TabButton(image: "exersice", title: "Exersices", animation: animation, currentTab: $currentTab)
                TabButton(image: "content", title: "Contents", animation: animation, currentTab: $currentTab)
                Button(action:{
                    LoginViewModel().logout()
                    isLogin = false
                }, label: {
                    HStack(spacing: 15){
                        Image(systemName:"infinity.circle" )
                            .font(.title2)
                            .foregroundColor( Color.blue )
                        Text("Logout")
                            .kerning(1.2)
                            .foregroundColor( Color.black )
                    }.padding(.leading, 5)
                })
                .padding(.vertical,12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .contentShape(Rectangle())
            }
            .padding(.leading, 20)
            .offset(x: 15)
            .padding(.top,20)
            Spacer()
        }.frame(width: 210)
        
    }
}

struct TabButton :View {
    var image: String
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    var body: some View {
        Button(action:{
            withAnimation{
            currentTab = title
            }
        }, label: {
            HStack(spacing: 15){
        
//                Image(systemName:currentTab == title ? image : "\(image).fill" )
//                    .font(.title2)
//                    .foregroundColor(currentTab == title ?   Color.white : Color.primaryy )
                Text(title)
                    .kerning(1.2)
                    .foregroundColor(currentTab == title ?   Color.white : Color.black )
            }.padding(.leading, 5)
        })
        .padding(.vertical,12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(5)
        .background(currentTab == title ? Color.primaryy :Color.white)
        .contentShape(Rectangle())
    }
}
