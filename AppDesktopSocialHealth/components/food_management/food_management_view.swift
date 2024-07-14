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
    @State var selectedFood = Food(id: 0, name: "", description: "", calorie: 0, protein: 0, fat: 0, carb: 0, sugar: 0, serving: 0, photos: [PhotoFood(id: 0, photoType: "", image: Data(), url: "", dishId: "")])
    var body: some View {
        VStack(alignment: .center){
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Text("Food List")
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
                            .stroke( Color.white,lineWidth: 3)
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
                            .foregroundColor(.clear)
                    })
                }.padding()
              
                    RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)

                        .overlay{
                            VStack{
                                if isNew && isAdd {
                                    FoodDetailView(food: Food(id: 0, name: "", description: "", calorie: 0, protein: 0, fat: 0, carb: 0, sugar: 0, serving: 0, photos: [PhotoFood(id: 0, photoType: "", image: Data(), url: "", dishId: "")]), isNew: $isNew, isAdd:$isAdd, model: model)
                                }else if !isNew && isAdd {
                                    FoodDetailView(food: selectedFood, isNew: $isNew, isAdd:$isAdd,model: model)
                                        
                                }else{
                                    foodGrid
                                        .padding()
                                Divider()
                                    .font(.title2)
                                    .padding()
                                Spacer()
                                        }
                            }
                        }
                        .padding([.top, .leading], 50)
                        .foregroundColor(.clear)
                .padding([.top, .leading] )
                .background(Color.clear)
                    .navigationTitle("Foods")
                    .searchable(text: $searchText, prompt: "Look for something")
                    .alert(NSLocalizedString("Are you sure to delete \(selectedFood.id)", comment: ""), isPresented: $alertSureToDelete) {
                        Button("OK", role: .destructive) {
                            model.DeleteFoodById(food:selectedFood ){
                                sucess in
                                if sucess {
                                    alertDeleteSuccess = true
                                }else {
                                    alertDeleteFail = true
                                }
                            }
                        }
                    }
                    .alert(NSLocalizedString("Delete success", comment: ""), isPresented: $alertDeleteSuccess) {
                        Button("OK", role: .cancel) {
                            model.foods = []
                            model.fetchAllFood() { _ in }
                        }
                    }
                    .alert(NSLocalizedString("Delete fail: món ăn vẫn đang tồn tại nơi khác không xoá được ", comment: ""), isPresented: $alertDeleteFail) {
                        Button("OK", role: .cancel) {
                            
                        }
                    }
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
                    .foregroundColor(.white)
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("calorie")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("serving")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.white)
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
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(food.name)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(food.calorie)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(food.serving)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    
                    edit()
                    
                }, label: {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
        })
        .buttonStyle(PlainButtonStyle())
                Button(action: {
                    alertSureToDelete = true
                    selectedFood = food
                    
                }, label: {
                    Image("delete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
        })
        .buttonStyle(PlainButtonStyle())
        .padding(.leading)
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

