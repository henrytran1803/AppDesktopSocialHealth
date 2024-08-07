//
//  customtextfield.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 12/7/24.
//

import SwiftUI


struct CustomTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    @FocusState var focused: Bool
    
    var body: some View {
        let isActive = focused || text.count > 0
        
        ZStack(alignment: isActive ? .topLeading : .center) {
            TextField("", text: $text)
                .frame(height: 24)
                .font(.system(size: 16, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
                .foregroundColor(.black)
            HStack {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .onTapGesture {
            focused = true
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 56)
        .padding(.horizontal, 16)
        .background(.clear)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? .white.opacity(0.6) : .white.opacity(0.2), lineWidth: 2)
        }
    }
}
struct CustomText: View {
    
    @Binding var text: String
    let placeholder: String
    
    @FocusState var focused: Bool
    
    var body: some View {
        let isActive = focused || text.count > 0
        
        ZStack(alignment: isActive ? .topLeading : .center) {
            Text(text)
                .frame(height: 24)
                .font(.system(size: 16, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
                .background(.clear)
                .foregroundColor(.white)
            HStack {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .onTapGesture {
            focused = true
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 56)
        .padding(.horizontal, 16)
        .background(.clear)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? .white.opacity(0.6) : .white.opacity(0.2), lineWidth: 2)
        }
    }
}
