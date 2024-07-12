//
//  home_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct home_view: View {
    @State var currentTab = "Home"
    @Binding var isLogin: Bool
    var body: some View {
        HStack{
            VStack{
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: getRect().width / 9, height: getRect().height / 2.5 , alignment: .leading)
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [ Color("\(currentTab).fill"), Color.undersidebar ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(30)
                    .overlay {
                        SideMenu(currentTab: $currentTab, isLogin: $isLogin)
                        
                    }
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
                Spacer()
//                Image("imagefit")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: getRect().width / 9)
            }.padding()
            if currentTab == "Home" {
                ws()
            }else if currentTab == "Accounts" {
                account_management_view()
            }else if currentTab == "Foods" {
                food_management_view()
            }else if currentTab == "Exersices" {
                exersice_management_view()
            }
            else if currentTab == "Contents" {
                content_management_view()
            }
        }.frame(width: getRect().width / 1.3, height: getRect().height - 100 , alignment: .leading)
            .background(LinearGradient(
                gradient: Gradient(colors: [Color(currentTab), Color.under ]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .buttonStyle(PlainButtonStyle())
    }
}
