//  BaseNetwork.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

//
// NetworkService.swift
// BartenderApp
//
// Created by Taner Çelik on 13.05.2024.
//

import Foundation

class Network<T: Decodable> {
    func get<R>(_ endpoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], method: String = "GET", completion: @escaping (R) -> Void) where R: Decodable {
        guard let url = URL(string: AppConst.apiBaseURL + endpoint) else {
            completion(try! JSONDecoder().decode(R.self, from: Data()))
            return
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.httpMethod = method.uppercased()

        urlRequest.setValue(AppConst.apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        urlRequest.setValue(AppConst.apiHost, forHTTPHeaderField: "X-RapidAPI-Host")

        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if !parameters.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(try! JSONDecoder().decode(R.self, from: Data()))
                return
            }

            guard let data = data else {
                print("No data returned from API")
                completion(try! JSONDecoder().decode(R.self, from: Data()))
                return
            }

            do {
                let result = try JSONDecoder().decode(R.self, from: data)
                completion(result)
            } catch {
                print("Error parsing data: \(error.localizedDescription)")
                completion(try! JSONDecoder().decode(R.self, from: Data()))
            }
        }.resume()
    }
}
