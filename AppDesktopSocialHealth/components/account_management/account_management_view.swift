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
        VStack(alignment: .center){
            if isLoading {
                ProgressView()
            }else {
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
                .alert("Bạn có chắc muốn enable \(selectedUser.id)", isPresented: $alertSureToDelete) {
                    Button("OK", role: .destructive) { }
                    Button("Cancel", role: .cancel) { }
                }
            
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
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
                    .foregroundColor(.clear)
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
            .background(Color.clear)
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
                    .foregroundColor(.white)
                Text("First Name")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Last Name")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Status")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.white)
                
            }.font(.title)
                .bold()
            
            Divider()
            
            ForEach(filteredUsers, id: \.id) { user in
                Button(action: {
                    selectedUser = user
                    isNavigationActive = true
                }) {
                    GridRowUser(user: user, selectedUser: $selectedUser, isNew: $isNew, isAdd: $isAdd,alertSureToDelete: $alertSureToDelete)
//                        .background(user.status == 1 ? Color.red.opacity(0.1) : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(.clear)
                    
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
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.firstname)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.lastname)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(user.email)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
            Text("•")
                    .bold()
                    .font(.system(size: 40))
                    .foregroundColor(user.status == 0 ?Color.green: Color.red)
            Text(user.status == 0 ? "Active": "Suspend")
                    .foregroundColor(user.status == 0 ?Color.green: Color.red)
                
        }.frame(maxWidth: .infinity, alignment: .leading)
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
                    selectedUser = user
                    
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
        selectedUser = user
    }
    func edit() {
        isAdd = true
        isNew = false
        selectedUser = user
    }
}
