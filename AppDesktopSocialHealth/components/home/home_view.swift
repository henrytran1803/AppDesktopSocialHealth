//
//  home_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct home_view: View {
    @State var currentTab = "Home"
    @Binding var isLogin: Bool
    var body: some View {
        HStack{
            VStack{
                Spacer()
//                Button("Show Side Menu") {
//                    let sideMenuWindow = NSWindow(
//                        contentRect: NSRect(x: 0, y: 0, width: 200, height: 300),
//                        styleMask: [.titled, .closable, .miniaturizable],
//                        backing: .buffered,
//                        defer: false
//                    )
//                    sideMenuWindow.title = "Side Menu"
//                    
//                    // Calculate the position relative to the main window
//                    let mainWindowFrame = NSApplication.shared.mainWindow?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600) // Default size if no main window
//                    let sideMenuPosition = NSPoint(x: mainWindowFrame.minX + 50, y: mainWindowFrame.maxY - 350) // Example positioning
//                    
//                    sideMenuWindow.contentView = NSHostingView(rootView: ContentView())
//                    sideMenuWindow.makeKeyAndOrderFront(nil)
//                    sideMenuWindow.setFrameOrigin(sideMenuPosition)
//                }
//                .padding()
                
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: getRect().width / 9, height: getRect().height - 200 , alignment: .leading)
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [ Color("\(currentTab).fill"), Color.undersidebar ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(30)
                    .overlay {
                        SideMenu(currentTab: $currentTab, isLogin: $isLogin)
                        
                    }
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
                Spacer()

            }.padding()
            ///
            if currentTab == "Home" {
                main_view()
            }else if currentTab == "Accounts" {
                account_management_view()
            }else if currentTab == "Foods" {
                food_management_view()
            }else if currentTab == "Exersices" {
                exersice_management_view()
            }
            else if currentTab == "Contents" {
                content_management_view()
            }
        }.frame(width: getRect().width / 1.3, height: getRect().height - 100 , alignment: .leading)
            .background(LinearGradient(
                gradient: Gradient(colors: [Color(currentTab), Color.under ]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .buttonStyle(PlainButtonStyle())
    }
}
struct bar :View {
    
    @Binding var currentTab : String
    @Binding var isLogin : Bool
    var body: some View {
        VStack{
            Spacer()
            RoundedRectangle(cornerRadius: 30)
                .frame(width: getRect().width / 9, height: getRect().height - 200 , alignment: .leading)
                .foregroundColor(.clear)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [ Color("\(currentTab).fill"), Color.undersidebar ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(30)
                .overlay {
                    SideMenu(currentTab: $currentTab, isLogin: $isLogin)
                    
                }
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5  )
            Spacer()

        }
    }
}
