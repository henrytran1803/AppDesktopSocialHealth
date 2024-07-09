//
//  ImagePickerView.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 7/7/24.
//
import SwiftUI

struct ImagePickerView: View {
    @ObservedObject var viewModel:ImagePickerViewModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                       VStack {
                           Image(nsImage: viewModel.selectedImages[index])
                               .resizable()
                               .scaledToFit()
                               .frame(width: 100, height: 100)
                               .clipped()
                               .cornerRadius(8)
                           Button(action: {
                               viewModel.selectedImages.remove(at: index)
                           }, label: {
                               Text("Remove")
                                   .padding()
                                   .background(Color.red)
                                   .foregroundColor(.white)
                                   .cornerRadius(8)
                           })
                       }
                    }
                }
            }
            Button(action: {
                viewModel.selectImages()
            }) {
                Text("Select Images")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
