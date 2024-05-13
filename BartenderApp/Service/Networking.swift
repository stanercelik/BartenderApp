//
//  fetchData.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import Foundation
import UIKit

class Networking {
    let apiKey = "06dbeafbeamsh11ada475d2c869ap173c24jsn6881af0705fb"
    let apiHost = "the-cocktail-db3.p.rapidapi.com"
    let apiBaseURL = "https://the-cocktail-db3.p.rapidapi.com/"

    func fetchCocktails(completion: @escaping ([CocktailModel]) -> Void) {
        guard let url = URL(string: apiBaseURL) else {
            completion([])
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(apiHost, forHTTPHeaderField: "X-RapidAPI-Host")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching cocktails: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = data else {
                print("No data returned from API")
                completion([])
                return
            }

            print("Received data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")

            do {
                let cocktailModels = try JSONDecoder().decode([CocktailModel].self, from: data)
                completion(cocktailModels)
            } catch {
                print("Error parsing cocktails: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}
