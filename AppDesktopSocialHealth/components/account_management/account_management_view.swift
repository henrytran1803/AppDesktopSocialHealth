//
//  account_management_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI
struct account_management_view: View {
    @StateObject private var model = UserViewModel()
    @State private var searchText = ""
    @State var isAdd = false
    @State var isNew = false
    @State var alertSureToDelete = false
    @State var alertDeleteSuccess = false
    @State var alertDeleteFail = false
    @State private var selectedUser: User = User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0)
        @State private var isNavigationActive: Bool = false
    @State var isLoading = true

    var body: some View {
        VStack {
            
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
                .alert("Bạn có chắc muốn enable \(selectedUser.id)", isPresented: $alertSureToDelete) {
                    Button("OK", role: .destructive) { }
                    Button("Cancel", role: .cancel) { }
                }
            if isLoading {
                ProgressView()
            }else {
                RoundedRectangle(cornerRadius: 25)
                    .overlay{
                        VStack{
                            if isNew && isAdd {
                                UserDetailView(user: User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0), isNew: $isNew, isAdd:$isAdd)
                                    .onDisappear {
                                        model.users = []
                                        model.fetchAllUser { _ in }
                                    }
                            }else if !isNew && isAdd {
                                UserDetailView(user: selectedUser ?? User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0), isNew: $isNew, isAdd:$isAdd)
                                    .onDisappear {
                                        model.users = []
                                        model.fetchAllUser { _ in }
                                    }
                            }else{
                                Divider()
                                userGrid
                                    .font(.title2)
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding([.top, .leading] )
                    .alert(NSLocalizedString("Are you sure to delete \(selectedUser.id)", comment: ""), isPresented: $alertSureToDelete) {
                        Button("OK", role: .destructive) {
                            UserViewModel().deleteUser(userInput: selectedUser){
                                sucess in
                                if sucess {
                                    alertDeleteSuccess = false
                                }else {
                                    alertDeleteFail = false
                                }
                            }
                        }
                    }
                    .alert(NSLocalizedString("Delete success", comment: ""), isPresented: $alertDeleteSuccess) {
                        Button("OK", role: .cancel) {
                            model.users = []
                            model.fetchAllUser { _ in }
                        }
                    }
                    .alert(NSLocalizedString("Delete fail", comment: ""), isPresented: $alertDeleteFail) {
                        Button("OK", role: .cancel) {
                            
                        }
                    }
            .background(Color.primaryy)
                .navigationTitle("Users")
                .searchable(text: $searchText, prompt: "Look for something")
        }
        }
        .onAppear {
            isLoading = true
            model.fetchAllUser { success in
                if !success {
                    print("Failed to fetch users")
                }else{
                    isLoading = false
                }
            }
        }
    }
    
    private var userGrid: some View {
        Grid (alignment:.leading){
            GridRow {
                Text("ID")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("First Name")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Last Name")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.purple)
                Text("Status")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.black)
                
            }.font(.title)
                .bold()
            
            Divider()
            
            ForEach(filteredUsers, id: \.id) { user in
                Button(action: {
                    selectedUser = user
                    isNavigationActive = true
                }) {
                    GridRowUser(user: user, selectedUser: $selectedUser, isNew: $isNew, isAdd: $isAdd,alertSureToDelete: $alertSureToDelete)
                        .background(user.status == 1 ? Color.red.opacity(0.3) : Color.clear)
                        .cornerRadius(8)
                    
                }
            }
        }
    }
    
    private var filteredUsers: [User] {
        if searchText.isEmpty {
            return model.users
        } else {
            return model.users.filter {
                ($0.firstname.lowercased().contains(searchText.lowercased()) ||
                 $0.lastname.lowercased().contains(searchText.lowercased()) ||
                 $0.email.lowercased().contains(searchText.lowercased()))
            }
        }
    }
}
struct GridRowUser: View {
    var user: User
    @Binding var selectedUser: User
    @Binding var isNew: Bool
    @Binding var isAdd: Bool
    @Binding var alertSureToDelete:Bool
    var body: some View {
        HStack {
            Text("\(user.id)")
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.firstname)
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.lastname)
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.email)
                .foregroundColor(.purple)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.status == 0 ? "Active": "Suspend")
                .foregroundColor(.white)
                .cornerRadius(5)
                .background(user.status == 0 ?Color.green: Color.red)
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
                    
                    selectedUser = user
                    
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
        selectedUser = user
    }
    func edit() {
        isAdd = true
        isNew = false
        selectedUser = user
    }
}
