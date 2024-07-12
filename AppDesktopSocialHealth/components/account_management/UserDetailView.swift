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
                    CustomTextField(text: Binding(
                        get: { "\(user.id)" },
                        set: { user.id = Int($0) ?? 0 }
                    ), placeholder: "ID")
                    
                }.padding()
                VStack {
                    CustomTextField(text: $user.email
                    , placeholder: "Email")
                    
                }.padding()
                
            }
            HStack{
                VStack {
                    
                    CustomTextField(text: $user.firstname
                    , placeholder: "Fist name")

                }.padding()
                VStack {
                    
                    
                    CustomTextField(text: $user.lastname
                    , placeholder: "Last name")
                    
                }.padding()
            }
            HStack{
                VStack {
                    
                    CustomTextField(text: Binding(
                        get: { "\(user.height)" },
                        set: { user.height = Double($0) ?? 0 }
                    ), placeholder: "Height")
                    
                }.padding()
                VStack {
                    CustomTextField(text: Binding(
                        get: { "\(user.weight)" },
                        set: { user.weight = Double($0) ?? 0 }
                    ), placeholder: "Weight")
                    
                }.padding()
            }
            HStack{
                VStack {
                    
                    CustomTextField(text: Binding(
                        get: { "\(user.bdf)" },
                        set: { user.bdf = Double($0) ?? 0 }
                    ), placeholder: "BDF")
                    
                    
                }.padding()
                VStack {
                    
                    CustomTextField(text: Binding(
                        get: { "\(user.tdee)" },
                        set: { user.tdee = Double($0) ?? 0 }
                    ), placeholder: "TDEE")
                    
                }.padding()
            }
            HStack{
                VStack {
                    
                    CustomTextField(text: Binding(
                        get: { "\(user.calorie)" },
                        set: { user.calorie = Double($0) ?? 0 }
                    ), placeholder: "Calorie")
                   
                }.padding()

            }
Spacer()
            HStack{
                SecondaryButton(action: {
                    cancel()
                }, title: "CANCEL")
                .padding()
                
                
                PrimaryButton(action: {
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
                }, title: isAdd ? "EDIT": "ADD")
                
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
