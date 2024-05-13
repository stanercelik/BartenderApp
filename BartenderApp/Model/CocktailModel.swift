//
//  CocktailModel.swift
//  BartenderApp
//
//  Created by Taner Çelik on 12.05.2024.
//

import Foundation

struct CocktailModel: Codable {
    let id: String
    let title: String
    let difficulty: String
    let image: URL
}
