//
//  fooddetail_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 7/7/24.
//

import SwiftUI

struct FoodDetailView: View {
    @State var food : Food
    @Binding var isNew :Bool
    @Binding var isAdd :Bool
    @ObservedObject var modelImage = ImagePickerViewModel()
    @ObservedObject var model : FoodViewModel
    @State var alertCantUpdate = false
    @State var alertUpdateSuccess = false
    @State var alertCreatefail = false
    @State var alertCreateSuccess = false
    @State var alertEmpty = false
    var body: some View {
        VStack{
            HStack{
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(food.id)" },
                        set: { food.id = Int($0) ?? 0 }
                    ), placeholder: "ID")
                    
                }.padding()
                VStack {
                        CustomTextField(text: $food.name
                        , placeholder: "Name")
                }.padding()
            }
            HStack{
                VStack {
                    CustomTextField(text: $food.description
                    , placeholder: "description")
                   
                }.padding()
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(food.calorie)" },
                        set: { food.calorie = Double($0) ?? 0 }
                    ), placeholder: "calorie")
                   
                }.padding()
                
            }
            HStack{
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(food.protein)" },
                        set: { food.protein = Double($0) ?? 0 }
                    ), placeholder: "protein")
                    
                   
                }.padding()
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(food.fat)" },
                        set: { food.fat = Double($0) ?? 0 }
                    ), placeholder: "fat")
                }.padding()
                
            }
            HStack{
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(food.carb)" },
                        set: { food.carb = Double($0) ?? 0 }
                    ), placeholder: "carb")
                    
                  
                }.padding()
                VStack {
                    HStack {
                        CustomTextField(text: Binding(
                            get: { "\(food.serving)" },
                            set: { food.serving = Int($0) ?? 0 }
                        ), placeholder: "serving")
                        
                    }
                }.padding()
            }
                HStack{
                    HStack {
                        ForEach(food.photos, id: \.id) { photo in
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
                }
            HStack{
                SecondaryButton(action: {
                    cancel()
                }, title: "CANCEL")
                .padding()
                
                
                PrimaryButton(action: {
                    
                    if food.name.isEmpty {
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
                            let foodCreate = FoodCreate(
                                name: food.name,
                                description: food.description,
                                calorie: food.calorie,
                                protein: food.protein,
                                fat: food.fat,
                                carb: food.carb,
                                sugar: food.sugar,
                                serving: food.serving,
                                photos: photos
                            )
                            model.createFood(food: foodCreate) { success in
                                if success {
                                    alertCreateSuccess = true
                                } else {
                                    alertCreatefail = true
                                }
                            }
                        }else {
                            model.FoodUpdate(food: FoodUpdate(id: food.id, name: food.name, description: food.description, calorie: food.calorie, protein: food.protein, fat: food.fat, carb: food.carb, sugar: food.sugar, serving: food.serving)){
                                success in
                                if success {
                                    if modelImage.selectedImages.count == 1 {
                                        if let imageData = modelImage.selectedImages[0].tiffRepresentation {
                                            let photo = PhotoBase(photo_type: "1", image: imageData, url: "", dish_id: "\(food.id)")
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
                                                let photo = PhotoBase(photo_type: "1", image: imageData, url: "", dish_id: "\(food.id)")
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
                }, title: isAdd ? "EDIT": "ADD")
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
        }.foregroundColor(.black)
    }
        func cancel(){
            isNew = false
            isAdd = false
            
        }
}




