//
//  user_viewmodel.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 6/7/24.
//

import Foundation
class UserViewModel: ObservableObject {
    @Published var users : [User] = []
    @Published var createUser:User = User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0)
   
    func fetchAllUser(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.getAllUser.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.getAllUser.method
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
                print(data)
                do {
                    let userResponse = try JSONDecoder().decode(UserResponseData.self, from: data)
                    self.users = userResponse.data
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }

        dataTask.resume()
    }
    func updateUser(userInput: UserUpdate, completion: @escaping (Bool) -> Void) {
        print(userInput)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.updateUser(id: userInput.id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.updateUser(id: userInput.id).method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(userInput)
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

                completion(true)
            }
        }

        dataTask.resume()
    }
    func deleteUser(userInput: User, completion: @escaping (Bool) -> Void) {
        print(userInput)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.deleteUser(id: userInput.id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.deleteUser(id: userInput.id).method
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
    func createUser(userInput: UserCreate, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.createUser.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.createUser.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try JSONEncoder().encode(userInput)
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
                completion(true)
                
            }
        }
        
        dataTask.resume()
    }
}
