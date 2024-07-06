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
            SideMenu(currentTab: $currentTab, isLogin: $isLogin)
            
            if currentTab == "Home" {
                main_view()
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
            .background(Color.background.ignoresSafeArea())
            .buttonStyle(PlainButtonStyle())
    }
}
