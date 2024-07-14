//
//  exersice_detail_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 10/7/24.
//

import SwiftUI

struct exersice_detail_view: View {
    @State var exersice : Exersice
    @Binding var isNew :Bool
    @Binding var isAdd :Bool
    @ObservedObject var modelImage = ImagePickerViewModel()
    @ObservedObject var model : ExersiceViewModel
    @State var alertCantUpdate = false
    @State var alertUpdateSuccess = false
    @State var alertCreatefail = false
    @State var alertCreateSuccess = false
    @State var alertEmpty = false
    
    @State private var selectedExersiceId: Int? = nil

    
    var body: some View {
        VStack{
            HStack{
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(exersice.id)" },
                        set: { exersice.id = Int($0) ?? 0 }
                    ), placeholder: "ID")
                }.padding()
                VStack {
                        CustomTextField(text: $exersice.name
                        , placeholder: "Name")
                }.padding()
                
            }
            HStack{
                VStack {
                    
                    CustomTextField(text: $exersice.description
                    , placeholder: "description")
                    
                }.padding()
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(exersice.calorie)" },
                        set: { exersice.calorie = Double($0) ?? 0 }
                    ), placeholder: "calorie")
                 
                }.padding()
                
            }
            HStack{
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(exersice.rep_serving)" },
                        set: { exersice.rep_serving = Int($0) ?? 0 }
                    ), placeholder: "Rep serving")
                    
                }.padding()
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(exersice.time_serving)" },
                        set: { exersice.time_serving = Int($0) ?? 0 }
                    ), placeholder: "Time serving")
                    
                }.padding()
                
            }
            HStack{
                PickerTypeCustom(exs: $model.exersicesType, selectedEx: $selectedExersiceId)
                    .padding()
               
            }
                HStack{
                    HStack {
                        ForEach(exersice.photo, id: \.id) { photo in
                           VStack {
                               
                               if let imageData = photo.image, let nsImage = NSImage(data: imageData) {
                                   Image(nsImage: nsImage)
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .frame(width: 100)
                               } else {
                                   Text("Invalid image data")
                               }
                               Button(action: {
                                   modelImage.deletePhoto(id: photo.id){sucess in
                                       
                                   }
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
                    ImagePickerView(viewModel: modelImage)
                }.padding()
          
            
            HStack{
           
                
                SecondaryButton(action: {
                    cancel()
                }, title: "CANCEL")
                .padding()
                
                PrimaryButton(action: {
                    
                    if exersice.name.isEmpty {
                        alertEmpty = true
                    } else {
                        
                        if isNew {
                            var photos = [Data]()
                            for selectedImage in modelImage.selectedImages {
                                if let imageData = selectedImage.tiffRepresentation {
                                    photos.append(imageData)
                                } else {
                                    print("Failed to get image data for one of the images")
                                }
                            }
                            let exersiceCreate = ExersiceCreate(
                                name: exersice.name,
                                description: exersice.description,
                                calorie: exersice.calorie,
                                rep_serving: exersice.rep_serving, 
                                time_serving: exersice.time_serving,
                                exersice_type: selectedExersiceId ?? 1,
                                image: photos
                            )
                            print(exersiceCreate)
                            model.createExersice(exersice: exersiceCreate) { success in
                                if success {
                                    alertCreateSuccess = true
                                } else {
                                    alertCreatefail = true
                                }
                            }
                        }else {
                            
                            
                            model.updateExersice(exersice: ExersiceUpdate(id: exersice.id, name: exersice.name, description: exersice.description, calorie: exersice.calorie,rep_serving: exersice.rep_serving, time_serving: exersice.time_serving, exersice_type: selectedExersiceId  ?? exersice.exersice_type.id)){
                                success in
                                if success {
                                    if modelImage.selectedImages.count == 1 {
                                        if let imageData = modelImage.selectedImages[0].tiffRepresentation {
                                            let photo = PhotoBase(photo_type: "1", image: imageData, url: "", exersice_id: "\(exersice.id)")
                                            
                                            modelImage.createPhoto(photo: photo) { success in
                                                if success {
                                                    print("success")
                                                } else {
                                                    alertCreatefail = true
                                                }
                                            }
                                        } else {
                                            alertCreatefail = true
                                        }
                                    } else if modelImage.selectedImages.count > 1 {
                                        var photos = [PhotoBase]()
                                        
                                        for selectedImage in modelImage.selectedImages {
                                            if let imageData = selectedImage.tiffRepresentation {
                                                let photo = PhotoBase(photo_type: "1", image: imageData, url: "", exersice_id: "\(exersice.id)")
                                                photos.append(photo)
                                            } else {
                                                alertCreatefail = true
                                            }
                                        }
                                        
                                        for photo in photos {
                                            modelImage.createPhoto(photo: photo) { success in
                                                if success {
                                                    alertCreateSuccess = true
                                                } else {
                                                    alertCreatefail = true
                                                }
                                            }
                                        }
                                    } else {
                                        
                                        
                                        print("no images selected")
                                    }
                                }else {
                                    alertCantUpdate = true
                                }
                                
                            }
                        }
                    }
                }, title: isNew ? "ADD": "EDIT")
                
                
            }
            .alert(NSLocalizedString("error.empty", comment: ""), isPresented: $alertEmpty) {
                        Button("OK", role: .cancel) { }
                    }
            .alert(NSLocalizedString("Fail", comment: ""), isPresented: $alertCreatefail) {
                        Button("OK", role: .cancel) { }
                    }
                .alert(NSLocalizedString("Sucess", comment: ""), isPresented: $alertCreateSuccess) {
                Button("OK", role: .destructive) {   isNew = false
                    isAdd = false
                }
                    }
        }
        .onAppear{
            selectedExersiceId = exersice.exersice_type.id
        }
        .foregroundColor(.black)
    }
        func cancel(){
            isNew = false
            isAdd = false
            
        }
}




