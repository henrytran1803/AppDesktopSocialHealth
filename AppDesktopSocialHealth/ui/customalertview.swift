//
//  customalertview.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import Foundation
import SwiftUI
struct CustomAlertView<T: Hashable, M: View>: View {
    
    // 1.
    @Binding private var isPresented: Bool
    // 2.
    @State private var titleKey: LocalizedStringKey
    // 3.
    @State private var actionTextKey: LocalizedStringKey
  
    // 4.
    private var data: T?
    // 5.
    private var actionWithValue: ((T) -> ())?
    // 6.
    private var messageWithValue: ((T) -> M)?
  
    // 7.
    private var action: (() -> ())?
    // 8.
    private var message: (() -> M)?
  
    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        presenting data: T?,
        actionTextKey: LocalizedStringKey,
        action: @escaping (T) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
      
        self.data = data
        self.action = nil
        self.message = nil
        self.actionWithValue = action
        self.messageWithValue = message
    }
    var body: some View{
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0) // Choose the opacity you like.
            VStack {
                // TODO: Alert
            }
            .padding()
        }
        .ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)

        VStack {
            /// Title
            Text(titleKey)
                .font(.title2).bold()
                .foregroundStyle(.tint)
                .padding(8)
          
            /// Message
            Group {
                if let data, let messageWithValue {
                    messageWithValue(data)
                } else if let message {
                    message()
                }
            }
            .multilineTextAlignment(.center)
          
            /// Buttons
            HStack {
                CancelButton
                DoneButton
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .cornerRadius(35)
    }
    var CancelButton: some View {
        Button {
            isPresented = false
        } label: {
            Text("Cancel")
                .font(.headline)
                .foregroundStyle(.tint)
                .padding()
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .background(Material.regular)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
      
    var DoneButton: some View {
        Button {
            isPresented = false
            if let data, let actionWithValue {
                actionWithValue(data)
            } else if let action {
                action()
            }
        } label: {
            Text(actionTextKey)
                .font(.headline).bold()
                .foregroundStyle(Color.white)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 30.0))
        }
    }

}
extension CustomAlertView where T == Never {
    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) where T == Never {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
  
        self.data = nil
        self.action = action
        self.message = message
        self.actionWithValue = nil
        self.messageWithValue = nil
    }
}
//extension View {
//    func customAlert<M, T: Hashable>(
//        _ titleKey: LocalizedStringKey,
//        isPresented: Binding<Bool>,
//        presenting data: T?,
//        actionText: LocalizedStringKey,
//        action: @escaping (T) -> (),
//        @ViewBuilder message: @escaping (T) -> M
//    ) -> some View where M: View {
//  
//        fullScreenCover(isPresented: isPresented) {
//            CustomAlertView(
//                titleKey,
//                isPresented,
//                presenting: data,
//                actionTextKey: actionText,
//                action: action,
//                message: message
//            )
//            .presentationBackground(.clear)
//        }
//        // TODO: Disable fullScreenCover transition animation.
//    }
//    /// TODO: customAlert<M>...
//}
