//
//  food_management_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct food_management_view: View {
    @ObservedObject var model = FoodViewModel()
    @State private var searchText = ""
    @State var isAdd = false
    @State var isNew = false
    @State var alertSureToDelete = false
    @State var alertDeleteSuccess = false
    @State var alertDeleteFail = false
    @State var isLoading = true

    @State var selectedFood = Food(id: 0, name: "", description: "", calorie: 0, protein: 0, fat: 0, carb: 0, sugar: 0, serving: 0, photos: [Photo(id: 0, photoType: "", image: Data(), url: "", dishId: "")])
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Text("User List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    Spacer()
                    Button(action: {
                                            isAdd = true
                                            isNew = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 110, height: 40)
                            .overlay{
                                HStack{
                                    Text("ADD NEW")
                                        .foregroundColor(.white)
                                        .font( .title)
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font( .title)
                                }
                            }
                            .foregroundColor(.purple)
                    })
                }.padding()
              
                    RoundedRectangle(cornerRadius: 25)
                        .overlay{
                            VStack{
                                if isNew && isAdd {
                                    FoodDetailView(food: $selectedFood, isNew: $isNew, isAdd:$isAdd, model: model)
                                }else if !isNew && isAdd {
                                    FoodDetailView(food: $selectedFood, isNew: $isNew, isAdd:$isAdd,model: model)
                                        
                                }else{
                                    foodGrid
                                Divider()
                                    .font(.title2)
                                    .padding()
                                Spacer()
                                        }
                            }
                        }
                        .padding([.top, .leading], 50)
                
                .foregroundColor(.white)
                .padding([.top, .leading] )
                .background(Color.primaryy)
                
                    .navigationTitle("Users")
                    .searchable(text: $searchText, prompt: "Look for something")
                }
                    
        }.onAppear {isLoading = true
            model.fetchAllFood { success in
                if success {
                    isLoading = false
                    print("Failed to fetch users")
                }
            }
        }
    }
    private var foodGrid: some View {
        Grid (alignment:.leading){
            GridRow {
                Text("ID")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("calorie")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text("serving")
                    .font(.headline)
                    .foregroundColor(.purple)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.black)
            }.font(.title)
                .bold()
            
            Divider()
            
            ForEach(filteredFoods, id: \.id) { food in
                
                GridRowFood(food: food, selectedFood: $selectedFood, isNew: $isNew, isAdd: $isAdd,alertSureToDelete: $alertSureToDelete)
                    .cornerRadius(8)
            }
        }
    }
    
    private var filteredFoods: [Food] {
        if searchText.isEmpty {
            return model.foods
        } else {
            return model.foods.filter {
                ($0.name.lowercased().contains(searchText.lowercased()))
            }
        }
    }
}
struct GridRowFood: View {
    var food: Food
    @Binding var selectedFood: Food
    @Binding var isNew: Bool
    @Binding var isAdd: Bool
    @Binding var alertSureToDelete:Bool
    var body: some View {
        HStack {
            Text("\(food.id)")
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(food.name)
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(food.calorie)")
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(food.serving)")
                .foregroundColor(.purple)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    
                    edit()
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 50, height: 30)
                        .overlay{
                            Text("Sửa")
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.orange)
                })
                Button(action: {
                    alertSureToDelete = true
                    
//                    selectedUser = food
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 50, height: 30)
                        .overlay{
                            Text("Xoá")
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.red)
                })
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
    func addNew() {
        isAdd = true
        isNew = true
        selectedFood = food
    }
    func edit() {
        isAdd = true
        isNew = false
        selectedFood = food
    }
}

