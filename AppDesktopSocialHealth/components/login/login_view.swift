//
//  login_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct login_view: View {
    @Binding var isLogin:Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var login : LoginViewModel = LoginViewModel()
    @State var showAlert = false
    @State var showAlertEmpty = false
    var body: some View {
        HStack(spacing:0){
            Image("Gym promotion template (Instagram Story)")
                .resizable()
                .scaledToFit()
                .frame(height: getRect().height - 100)
            Spacer()
            VStack(){
                Spacer()
                Image(colorScheme == .light ? "3" : "4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Spacer()
                VStack(alignment: .leading){
                    Text(NSLocalizedString("text.username", comment: ""))
                        .font(.title2)
                        .foregroundColor(.text)
                    TextField(NSLocalizedString("text.username", comment: ""), text: $login.login.email)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                    Text(NSLocalizedString("text.password", comment: ""))
                        .font(.title2)
                        .foregroundColor(.text)
                    SecureField(NSLocalizedString("text.password", comment: ""), text: $login.login.password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                }
                Button(action: {
                    if login.login.email.isEmpty || login.login.password.isEmpty {
                        showAlertEmpty = true
                    }else {
                        login.login{successs in
                            if successs{
                                isLogin = true
                            }else{
                                print("\(login.errorMessage)")
                                showAlert = true
                            }
                        }
                    }
                }, label: {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250, height: 50)
                        .overlay{
                            Text(NSLocalizedString("button.login", comment: ""))
                                .font( .title)
                                .foregroundStyle(.white)
                        }
                        .foregroundColor(Color.primaryy)
                        .background(Color.background)
                      
                        
                })
                .padding(.top, 50)
                Spacer()
                    .alert(NSLocalizedString("error.login", comment: ""), isPresented: $showAlert) {
                                Button("OK", role: .cancel) { }
                            }
                    .alert(NSLocalizedString("error.empty", comment: ""), isPresented: $showAlertEmpty) {
                                Button("OK", role: .cancel) { }
                            }
            }
            Spacer()
        }.frame(width: getRect().width / 1.3, height: getRect().height - 100 , alignment: .leading)
            .background(Color.background.ignoresSafeArea())
    }
}

extension View{
    func getRect() -> CGRect {
        return NSScreen.main!.visibleFrame
    }
}
