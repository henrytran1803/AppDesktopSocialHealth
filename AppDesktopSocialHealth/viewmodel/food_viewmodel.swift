//
//  food_viewmodel.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import Foundation
class FoodViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    func fetchAllFood(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        print(token)
        guard let url = API.getListFood.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.getListFood.method
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
                    let foodResponse = try JSONDecoder().decode(FoodResponseData.self, from: data)
                    self.foods = foodResponse.data
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func FoodUpdate(food: FoodUpdate,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.updateFoodNonePhoto.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.updateFoodNonePhoto.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try JSONEncoder().encode(food)
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
                self.foods = []
                self.fetchAllFood(){ success in
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
    func createFood(food: FoodCreate, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        
        guard let url = API.createFood.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.createFood.method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add text fields
        let fields: [String: String] = [
            "name": food.name,
            "description": food.description,
            "calorie": String(food.calorie),
            "protein": String(food.protein),
            "fat": String(food.fat),
            "carb": String(food.carb),
            "sugar": String(food.sugar),
            "serving": String(food.serving)
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add photos
        for (index, imageData) in food.photos.enumerated() {
            let filename = "photo\(index + 1).jpg"
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photos\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
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
                
                self.foods = []
                self.fetchAllFood(){ success in
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


    func DeleteFoodById(food: Food, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.deleteFood(id: food.id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.deleteFood(id: food.id).method
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
                
                if let index = self.foods.firstIndex(where: { $0.id == food.id }) {
                  self.foods.remove(at: index)
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
