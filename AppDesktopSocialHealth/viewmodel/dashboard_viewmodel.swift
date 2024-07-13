//
//  dashboard_viewmodel.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 13/7/24.
//

import Foundation
class DashBoardViewModel : ObservableObject {
    @Published var dashBoard : DashBoard = DashBoard(
        all_user: 0,
        user_disable: 0,
        count_posts: 0,
        count_food: 0,
        count_exersice: 0,
        count_photos: 0,
        active_user: 0,
        list_active: []
    )
    
    func fetchDashBoard(completion: @escaping (Bool) -> Void) {
     

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.dashBoard.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.dashBoard.method
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

                // Print received data for inspection
                print(String(data: data, encoding: .utf8) ?? "Data is not UTF-8 encoded")

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Set date decoding strategy
                    let userResponse = try decoder.decode(DashBoard.self, from: data)
                    self.dashBoard = userResponse
                    completion(true)
                } catch {
                    print("Failed to decode JSON:", error.localizedDescription)
                    completion(false)
                }
            }
        }

        dataTask.resume()
    }

}
