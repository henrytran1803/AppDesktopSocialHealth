//
//  exersice_management_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct exersice_management_view: View {
    @State var isAdd = false
    @State var isNew = false
    @State var searchText = ""
    @ObservedObject var model = ExersiceViewModel()
    @State var isLoading  = true
    @State var alertSureToDelete = false
    @State var alertDeleteSuccess = false
    @State var alertDeleteFail = false
    @State var selectedExersice = Exersice(id: 0, name: "", description: "", calorie: 0, rep_serving: 0, time_serving: 0, exersice_type: ExersiceType(id: 0, name: ""), photo: [])
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Text("Exersices List")
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
                                    exersice_detail_view(exersice: Exersice(id: 0, name: "", description: "", calorie: 0, rep_serving: 0, time_serving: 0, exersice_type: ExersiceType(id: 1, name: ""), photo: []), isNew: $isNew, isAdd:$isAdd, model: model)
                                }else if !isNew && isAdd {
                                    exersice_detail_view(exersice: selectedExersice, isNew: $isNew, isAdd:$isAdd, model: model)
                                }else{
                                    exersiceGrid
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
                
                .background(Color.clear)
                .padding([.top, .leading] )
                    .navigationTitle("Exersices")
                    .searchable(text: $searchText, prompt: "Look for something")
                    .alert(NSLocalizedString("Are you sure to delete \(selectedExersice.id)", comment: ""), isPresented: $alertSureToDelete) {
                        Button("OK", role: .destructive) {
                            model.deleteExersice(exersice: selectedExersice){
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

                        }
                    }
                    .alert(NSLocalizedString("Delete fail:Có vẻ như nó đang được sử dụng ở nơi khác ", comment: ""), isPresented: $alertDeleteFail) {
                        Button("OK", role: .cancel) {
                            
                        }
                    }
                }
        }.onAppear{
            isLoading = true
            model.fetchAllExersice{ success in
                if success {
                    isLoading = false
                }else {
                    print("error to fetch exersices")
                }
                
                model.fetchAllExersiceType{ success in
                    if success {
                        
                    }else {
                        print("error to fetch exersices")
                    }
                }
            }
        }
    }
    private var exersiceGrid: some View {
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
                Text("Exersice type")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.white)
            }.font(.title)
                .bold()
            Divider()
            ForEach(filteredExersices, id: \.id) { exersice in
                GridRowExersice(exersice: exersice, selectedExersice: $selectedExersice, isNew: $isNew, isAdd: $isAdd,alertSureToDelete: $alertSureToDelete)
                    .cornerRadius(8)
            }
        }
    }
    private var filteredExersices: [Exersice] {
        if searchText.isEmpty {
            return model.exersices
        } else {
            return model.exersices.filter {
                ($0.name.lowercased().contains(searchText.lowercased()))
            }
        }
    }
}
struct GridRowExersice: View {
    var exersice: Exersice
    @Binding var selectedExersice: Exersice
    @Binding var isNew: Bool
    @Binding var isAdd: Bool
    @Binding var alertSureToDelete:Bool
    var body: some View {
        HStack(alignment: .center) {
            Text("\(exersice.id)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(exersice.name)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(exersice.calorie)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(exersice.exersice_type.name)")
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
                    selectedExersice = exersice
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
        selectedExersice = exersice
    }
    func edit() {
        isAdd = true
        isNew = false
        selectedExersice = exersice
    }
}

