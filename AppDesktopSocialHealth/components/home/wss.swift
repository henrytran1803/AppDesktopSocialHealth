//
//  ws.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 11/7/24.
//

import SwiftUI

struct ws: View {
        @StateObject var model = WebSocketManager()
    
    
        @State private var message = ""

        var body: some View {
            VStack {
                Text("WebSocket Admin")
                    .font(.largeTitle)
                    .padding()

                CustomTextField(text: $message, placeholder: "Enter message")


                Button(action: {
                    model.sendMessageToAll(message: wssend(message: message)){
                        success in
                        if success {
                            
                        }else
                        {
                            
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
//                .disabled(!webSocketManager.isConnected)
                PrimaryButton(action: {
                               // Hành động của primary button
                           }, title: "PRIMARY BUTTON")

                           SecondaryButton(action: {
                               // Hành động của secondary button
                           }, title: "SECONDARY BUTTON")
                Spacer()
            }
            .padding()
        }
    }
