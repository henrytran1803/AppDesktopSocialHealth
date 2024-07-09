//
//  fooddetail_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 7/7/24.
//

import SwiftUI

struct FoodDetailView: View {
    @Binding var food : Food
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
                    HStack {
                        Text("ID")
                        TextField("ID", value: $food.id, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("Name")
                        TextField("Email", text: $food.name)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                
            }
            HStack{
                VStack {
                    HStack {
                        Text("description")
                        TextField("description", text: $food.description)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("calorie")
                        TextField("calorie", value: $food.calorie, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                
            }
            HStack{
                VStack {
                    HStack {
                        Text("protein")
                        TextField("protein", value: $food.protein, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("fat")
                        TextField("fat", value: $food.fat, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                
            }
            HStack{
                VStack {
                    HStack {
                        Text("carb")
                        TextField("carb", value: $food.carb, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("serving")
                        TextField("serving", value: $food.serving, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
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
                Button(action: {cancel()}, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 50)
                        .foregroundColor(.pink)
                        .overlay{
                            Text("CANCEL")
                                .font( .title)
                                .foregroundColor(.white)
                        }
                }).padding()
                Button(action: {
                    
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
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 50)
                        .foregroundColor(.green)
                        .overlay{
                            Text("SAVE")
                                .font( .title)
                                .foregroundColor(.white)
                        }
                }).padding()
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




