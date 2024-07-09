//
//  image_viewmodel.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 7/7/24.
//

import SwiftUI

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImages: [NSImage] = []
    
    func selectImages() {
        let panel = NSOpenPanel()
        panel.title = "Choose images"
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]
        panel.allowsMultipleSelection = true
        
        if panel.runModal() == .OK {
            for url in panel.urls {
                if let image = NSImage(contentsOf: url) {
                    selectedImages.append(image)
                }
            }
        }
    }
    func createPhoto(photo: PhotoBase,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.createPhoto.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.createPhoto.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try JSONEncoder().encode(photo)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user input: \(error.localizedDescription)")
            completion(false)
            return
        }
        print(url)
        print(request)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print(data)
                print(response)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response from server")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("No data received from server")
                    completion(false)
                    return
                }
                completion(true)
                
            }
        }
        
        dataTask.resume()
    }
    func createListPhoto(photo: [PhotoBase],completion: @escaping (Bool) -> Void) {
        
    }
    func deletePhoto(id: Int,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.deletePhotoById(photoId: id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.deletePhotoById(photoId: id).method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response from server")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("No data received from server")
                    completion(false)
                    return
                }
                completion(true)
                
            }
        }
        
        dataTask.resume()
    }
}
