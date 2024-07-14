//
//  main_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import SwiftUI
// tong so user, post, ex, fo
// post trong tuan qua
// gui thong bao cho nguoi dung

struct main_view: View {
    @StateObject var model = WebSocketManager()
@ObservedObject var modelDash = DashBoardViewModel()
@State var isSuccess = false
    @State var isFail = false

    @State private var message = ""

    var body: some View {
        VStack (alignment:.leading){
            Text("DashBoard")
                .bold()
                .font( .title)
                .foregroundColor(.white)
            HStack{
                Labeldashboardcustom(title: "All User", text:.constant("\(modelDash.dashBoard.all_user)"))
                Labeldashboardcustom(title: "User disable", text:.constant("\(modelDash.dashBoard.user_disable)"))
                LabeldashboardSendcustom(text: $message, isSuccess: $isSuccess, isFail: $isFail, model: model)
            }
            HStack{
                Labeldashboardcustom(title: "Exersice", text:.constant("\(modelDash.dashBoard.count_exersice)"))
                Labeldashboardcustom(title: "Food", text:.constant("\(modelDash.dashBoard.count_food)"))
                Labeldashboardcustom(title: "Photo", text:.constant("\(modelDash.dashBoard.count_photos)"))
                Labeldashboardcustom(title: "Post", text:.constant("\(modelDash.dashBoard.count_posts)"))
            }
            HStack{
                LabeldashboardChartUsercustom(all: $modelDash.dashBoard.all_user, dis: $modelDash.dashBoard.user_disable)
                Labeldashboardcustom(title: "Active user", text:.constant("\(modelDash.dashBoard.active_user)"))
                LabeldashboardUsercustom(active: Binding(
                           get: { modelDash.dashBoard.list_active ?? [] },
                           set: { modelDash.dashBoard.list_active = $0 }
                       ))
            }
            .navigationTitle("Dashboard")
        }
        
        .alert(NSLocalizedString("Gửi thông báo thành công", comment: ""), isPresented: $isSuccess) {
            Button("OK", role: .cancel) {
              
            }
        }
        .alert(NSLocalizedString("Gửi thông báo thành công", comment: ""), isPresented: $isFail) {
            Button("OK", role: .cancel) {
              
            }
        }
        .onAppear{
            modelDash.fetchDashBoard(){
                success in
                
            }
        }
        .padding()
    }
}
struct CustomOverlayView: NSViewRepresentable {
func makeNSView(context: Context) -> NSView {
    let view = NSView(frame: NSRect(x: -1000, y: 0, width: 300, height: 200))
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.blue.cgColor
    view.layer?.cornerRadius = 10
    return view
}

func updateNSView(_ nsView: NSView, context: Context) {
    // Update code here if needed
}
}

