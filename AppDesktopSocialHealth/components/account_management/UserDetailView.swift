//
//  UserDetailView.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import SwiftUI

struct UserDetailView: View {
    @State var user: User
    @Binding var isNew:Bool
    @Binding var isAdd:Bool
    @State var save = false
    @State var alertSuccess = false
    @State var alertEmpty = false
    @State var alertFail = false
    static var dateformater: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    static var numberFormater: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }
    var body: some View{
        VStack{
            HStack{
                VStack {
                    HStack {
                        Text("ID")
                        TextField("ID", value: $user.id, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("Email")
                        TextField("Email", text: $user.email)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                
            }
            HStack{
                VStack {
                    HStack {
                        Text("Fist name")
                        TextField("Fist name", text: $user.firstname)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("Last name")
                        TextField("Last name", text: $user.lastname)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
            }
            HStack{
                VStack {
                    HStack {
                        Text("Height")
                        TextField("Height", value: $user.height, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("Weight")
                        TextField("Weight",  value: $user.weight, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
            }
            HStack{
                VStack {
                    HStack {
                        Text("BDF")
                        TextField("BDF", value: $user.bdf, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
                VStack {
                    HStack {
                        Text("TDEE")
                        TextField("TDEE", value: $user.tdee, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()
            }
            HStack{
                VStack {
                    HStack {
                        Text("Calorie")
                        TextField("Calorie", value: $user.calorie, formatter: UserDetailView.numberFormater)
                            .textFieldStyle(KuteTextFieldStyle())
                    }
                }.padding()

            }
Spacer()
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
                    if user.email.isEmpty || user.firstname.isEmpty || user.lastname.isEmpty {
                        alertEmpty = true
                    }else {
                        if isNew {
                            UserViewModel().createUser(userInput: UserCreate(email: user.email, firstname: user.firstname, lastname: user.lastname, role: 1, height: user.height, weight: user.weight, bdf: user.bdf, tdee: user.tdee, calorie: user.calorie, status: user.status)){success in
                                if success {
                                    alertSuccess = true
                                }else {
                                    alertFail = true
                                }
                                
                            }
                        }else {
                            UserViewModel().updateUser(userInput: UserUpdate(id: user.id, email: user.email, firstname: user.firstname, lastname: user.lastname, role: 1, height: user.height, weight: user.weight, bdf: user.bdf, tdee: user.tdee, calorie: user.calorie, status: user.status)){success in
                                if success {
                                    alertSuccess = true
                                }else {
                                    alertFail = true
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
                
                .alert(NSLocalizedString("error.empty", comment: ""), isPresented: $alertEmpty) {
                            Button("OK", role: .cancel) { }
                        }
                .alert(NSLocalizedString("Fail", comment: ""), isPresented: $alertFail) {
                            Button("OK", role: .cancel) { }
                        }
                .alert(NSLocalizedString("Sucess", comment: ""), isPresented: $alertSuccess) {
                    Button("OK", role: .destructive) {   isNew = false
                        isAdd = false
                    }
                        }
            }
            Spacer()
        }.foregroundColor(.black)
    }
    func cancel(){
        isNew = false
        isAdd = false
        
    }
}

//struct UserUpdate:Codable {
//    var id: Int
//    var email: String
//    var firstname: String
//    var lastname: String
//    var role: Int
//    var height: Double
//    var weight: Double
//    var bdf: Double
//    var tdee: Double
//    var calorie: Double
//    var status: Int
//}

struct KuteTextFieldStyle: TextFieldStyle {
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        return configuration
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.blue)
            )
            .shadow(color: Color.gray.opacity(1.0),
                    radius: 3, x: 1, y: 2)
    }
    
}
