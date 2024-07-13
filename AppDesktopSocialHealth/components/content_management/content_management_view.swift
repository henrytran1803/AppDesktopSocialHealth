//
//  content_management_view.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 4/7/24.
//

import SwiftUI

struct content_management_view: View {
    @State var isDetail = false
    @State var searchText = ""
    @ObservedObject var model = PostViewModel()
    @State var isLoading  = true
    @State var alertSureToDelete = false
    @State var alertDeleteSuccess = false
    @State var alertDeleteFail = false
    @State var selectedPost = Post(id: 0, title: "", body: "", user_id: 0, count_likes: 0, count_comments: 0, photos: [])
    var body: some View {
        VStack(alignment: .center){
            if isLoading {
                ProgressView()
            } else {
                HStack{
                    Text("Post List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    Spacer()
                }.padding()
              
                    RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)

                        .overlay{
                            VStack{
                                if isDetail {
                                    contentdetail_view(post: selectedPost, sureTodelete: $alertSureToDelete,isDetail: $isDetail)
                                }else{
                                    postGrid
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
                    .alert(NSLocalizedString("Are you sure to delete \(selectedPost.id)", comment: ""), isPresented: $alertSureToDelete) {
                        Button("OK", role: .destructive) {
                            model.deletePostById(post: selectedPost){
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

                        }
                    }
                    .alert(NSLocalizedString("Delete fail", comment: ""), isPresented: $alertDeleteFail) {
                        Button("OK", role: .cancel) {
                            
                        }
                    }
                }
        }.onAppear{
            isLoading = true
            model.fetchAllPost(){ success in
                if success {
                    isLoading = false
                }else {
                    print("error to fetch exersices")
                }
            }
        }
    }
    private var postGrid: some View {
        Grid (alignment:.leading){
            GridRow {
                Text("ID")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Title")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Likes")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Comment")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Action")
                    .font(.headline)
                    .foregroundColor(.white)
            }.font(.title)
                .bold()
            Divider()
            ForEach(filteredPosts, id: \.id) { post in
                GridRowPost(post: post, selectedExersice: $selectedPost, isDetail: $isDetail)
                    .cornerRadius(8)
            }
        }
    }
    private var filteredPosts: [Post] {
        if searchText.isEmpty {
            return model.posts
        } else {
            return model.posts.filter {
                ($0.title.lowercased().contains(searchText.lowercased()) || $0.body.lowercased().contains(searchText.lowercased() ))
            }
        }
    }
}
struct GridRowPost: View {
    var post: Post
    @Binding var selectedExersice: Post
    @Binding var isDetail : Bool
    var body: some View {
        HStack {
            
            Text("\(post.id)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(post.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 300)
            Text("\(post.count_likes)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 300)
            Text("\(post.count_comments)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Button(action: {
                    selectedExersice = post
                    isDetail = true
                }, label: {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
        })
        .buttonStyle(PlainButtonStyle())
        .padding(.leading)
                Spacer()
            }
            
            
        }
        .padding(.vertical, 5)
    }
}

