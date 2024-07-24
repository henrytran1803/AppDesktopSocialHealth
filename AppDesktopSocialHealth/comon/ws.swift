//
//  ws.swift
//  AppDesktopSocialHealth
//
//  Created by Tran Viet Anh on 11/7/24.
//

import Foundation
//import Starscream
struct wssend: Codable{
    var message :String
}
class WebSocketManager: ObservableObject {
    func sendMessageToAll(message: wssend,completion: @escaping (Bool) -> Void) {
      
        guard var url = URL(string: "http://localhost:8080/broadcast") else { return completion(false) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(message)
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
