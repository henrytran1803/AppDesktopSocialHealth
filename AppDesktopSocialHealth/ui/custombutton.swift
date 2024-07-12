//
//  custombutton.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 12/7/24.
//

import Foundation
import SwiftUI


struct PrimaryButton: View {
    let action: () -> Void
    let title: String
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.line, lineWidth: 3)
                    .frame(width: 200, height: 60)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.uperbutton, Color.underbutton]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    )

                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .shadow(color: isHovered ? Color.line : Color.clear, radius: 10, x: 0, y: 0)
                .onHover { hovering in
                    isHovered = hovering
                }
    }
}

struct SecondaryButton: View {
    let action: () -> Void
    let title: String
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.line, lineWidth: 3)
                    .frame(width: 200, height: 60)
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.uperbutton, Color.underbutton]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                    )
                    .foregroundColor(.clear)

                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .shadow(color: isHovered ? Color.line : Color.clear, radius: 10, x: 0, y: 0)
                .onHover { hovering in
                    isHovered = hovering
                }
    }
}
