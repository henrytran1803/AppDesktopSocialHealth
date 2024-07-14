//
//  exersice_viewmodel.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 10/7/24.
//

import Foundation


class ExersiceViewModel:ObservableObject{
    
    @Published var exersices:[Exersice] = []
    @Published var exersicesType: [ExersiceType] = []
    func fetchAllExersice(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.getListExercise.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.getListExercise.method
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
                do {
                    let exResponse = try JSONDecoder().decode(ExersiceResponseData.self, from: data)
                    self.exersices = exResponse.data
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
    func fetchAllExersiceType(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.exType.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.exType.method
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
                do {
                    let exResponse = try JSONDecoder().decode([ExersiceType].self, from: data)
                    self.exersicesType = exResponse
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
    
    
    func updateExersice(exersice: ExersiceUpdate,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.updateExersiceNonePhoto.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.updateExersiceNonePhoto.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try JSONEncoder().encode(exersice)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user input: \(error.localizedDescription)")
            completion(false)
            return
        }
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
                self.exersices = []
                self.fetchAllExersice(){ success in
                    if success {
                        completion(true)
                        
                    }else {
                        completion(false)
                    }
                }
                
            }
        }
        
        dataTask.resume()
    }


    func createExersice(exersice: ExersiceCreate, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        
        guard let url = API.createExercise.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.createExercise.method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let fields: [String: String] = [
            "name": exersice.name,
            "description": exersice.description,
            "calorie": String(exersice.calorie),
            "rep_serving": String(exersice.rep_serving),
            "time_serving": String(exersice.time_serving),
            "exersice_type": String(exersice.exersice_type)
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        for (index, imageData) in exersice.image.enumerated() {
            let filename = "photo\(index + 1).jpg"
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
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
                
                guard let _ = data else {
                    print("No data received from server")
                    completion(false)
                    return
                }
                self.exersices = []
                self.fetchAllExersice(){ success in
                    if success {
                        completion(true)
                        
                    }else {
                        completion(false)
                    }
                }
            }
        }
        
        dataTask.resume()
    }

    
    func deleteExersice(exersice: Exersice,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.deleteExercise(id: exersice.id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.deleteExercise(id: exersice.id).method
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
                if let index = self.exersices.firstIndex(where: { $0.id == exersice.id }) {
                  self.exersices.remove(at: index)
                  completion(true)
              } else {
                  print("Không tìm thấy Exersice trong danh sách")
                  completion(false)
              }
            }
        }
        
        dataTask.resume()
    }

}
