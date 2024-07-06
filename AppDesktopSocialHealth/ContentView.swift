//
//  ContentView.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @State var isLogin = false
    
    var body: some View {
        Group {
            if isLogin {
                home_view(isLogin:$isLogin)
            } else {
                login_view(isLogin:$isLogin)
            }
        }
        .onAppear {
            isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
}

#Preview {
    ContentView()
}
