//
//  main_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import SwiftUI
// tong so user, post, ex, fo
// post trong tuan qua
// gui thong bao cho nguoi dung

struct main_view: View {
    @StateObject var model = WebSocketManager()
    @State private var message = ""
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .frame(width: 500, height: 500)
                .foregroundColor(.gray)
                .overlay{
                    
                    VStack{
                        Text("Gui thong bao den nguoi dung")
                            .font(.largeTitle)
                            .padding()
                        
                        CustomTextField(text: $message, placeholder: "Enter message")
                        Button(action: {
                            model.sendMessageToAll(message: wssend(message: message)){
                                success in
                                if success {
                                    
                                }else{
                                    
                                }
                            }
                        }) {
                            Text("Send Message")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                }
            
            
            
            
            
            
            
        }
        .padding()
    }

}
