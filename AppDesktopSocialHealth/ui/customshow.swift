//
//  customshow.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 13/7/24.
//

import Foundation
import SwiftUI
import Charts

        
struct Labeldashboardcustom : View{
    @State var title:String
    @Binding var text : String
    var body :some  View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: getRect().width / 8, height: getRect().width / 8 , alignment: .leading)
            .foregroundColor(.clear)
            .background(.white.opacity(0.2))
            .cornerRadius(30)
            .overlay {
                VStack(alignment: .center){
                        Text(title)
                            .bold()
                            .font(.system(size: getRect().width / 60))
                            .foregroundColor(.white)
                    Text(text)
                        .bold()
                        .font(.system(size: getRect().width / 20))
                        .foregroundColor(.white)
                }
                
            }
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
    }
}
struct LabeldashboardSendcustom : View{
    @Binding var text : String
    @Binding var isSuccess :Bool
    @Binding var isFail :Bool
    @ObservedObject var model : WebSocketManager
    var body :some  View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: getRect().width / 4, height: getRect().width / 8 , alignment: .leading)
            .foregroundColor(.clear)
            .background(.white.opacity(0.2))
            .cornerRadius(30)
            .overlay {
                VStack(alignment: .center){
                    CustomTextField(text: $text, placeholder: "Nhập thông báo")
                        .padding()
                    PrimaryButton(action: {
                        
                        model.sendMessageToAll(message: wssend(message: text)){success in
                            if success {
                                isSuccess = true
                            }else {
                                isFail = false
                            }
                            
                        }
                    }, title: "Gửi thông báo")
                }
            }
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
    }
}
struct LabeldashboardUsercustom : View{
    @Binding var active : [UserActive]
    var body :some  View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: getRect().width / 8, height: getRect().width / 5 , alignment: .leading)
            .foregroundColor(.clear)
            .background(.white.opacity(0.2))
            .cornerRadius(30)
            .overlay {
                VStack(alignment: .leading){
                    ScrollView {
                        ForEach(active,id: \.id_user){user in
                            HStack(){
                                Text("•")
                                    .bold()
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("ID: \(user.id_user)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Last login:\(user.last_login)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                
                            }
                        }
                    }
                    .foregroundColor(.clear)
                    .padding()
                }
            }
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
    }
}
struct DataChart: Identifiable {
    var type: String
    var count: Int
    var id = UUID()
}
struct LabeldashboardChartUsercustom: View {
    @Binding var all: Int
    @Binding var dis: Int
    @State private var data: [DataChart] = []
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: getRect().width / 4, height: getRect().width / 5, alignment: .leading)
            .foregroundColor(.clear)
            .background(.white.opacity(0.2))
            .cornerRadius(30)
            .overlay {
                Chart {
                    ForEach(data) { dataPoint in
                        BarMark(
                            x: .value("Shape Type", dataPoint.type),
                            y: .value("Total Count", dataPoint.count)
                        )
                    }
                }.padding()
                    .foregroundColor(  .blue.opacity(0.5))
//                .background(.clear)
            }
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5)
            .onAppear {
                updateData()
            }
            .onChange(of: all) { _ in
                updateData()
            }
            .onChange(of: dis) { _ in
                updateData()
            }
    }
    
    private func updateData() {
        data = [
            DataChart(type: "ALL", count: all),
            DataChart(type: "Active", count: all - dis),
            DataChart(type: "Suspend", count: dis)
        ]
    }
}
