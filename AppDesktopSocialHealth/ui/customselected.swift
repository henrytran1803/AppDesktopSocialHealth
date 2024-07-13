//
//  customselected.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 13/7/24.
//

import Foundation
import SwiftUI


struct PickerTypeCustom : View{
    @Binding var exs : [ExersiceType]
    @Binding var selectedEx : Int?
    var body :some  View {
        VStack {
                 Picker("Select Exercise", selection: $selectedEx) {
                     ForEach(exs, id : \.id) { exersice in
                         Text(exersice.name).tag(exersice.id as Int?)
                             .bold()
                             .foregroundColor(.white)
                     }
                 }
                 .pickerStyle(MenuPickerStyle())
             }
        .foregroundColor(.white)
        .background(.clear)
             .padding()
             .overlay{
                 RoundedRectangle(cornerRadius: 12)
                     .stroke(.white.opacity(0.2), lineWidth: 2)
             }

        
        
    }
}



