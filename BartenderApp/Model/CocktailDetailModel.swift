//
//  cocktailDetailModel.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import Foundation

struct CocktailDetailModel: Codable {
    let id: String
    let title: String
    let difficulty: String
    let portion: String
    let time: String
    let description: String
    let ingredients: [String]
    let method: [[String: String]]
    let image: URL
    //var isFavorite: Bool = false
}
