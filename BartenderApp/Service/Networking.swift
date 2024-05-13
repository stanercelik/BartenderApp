//
//  fetchData.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import Foundation
import UIKit

class Networking {
    
    let networkCocktails = Network<CocktailModel>()
    let networkCocktailDetail = Network<CocktailDetailModel>()
    
    
    func fetchCocktails(completion: @escaping ([CocktailModel]) -> Void) {
        networkCocktails.get("") { (cocktails: [CocktailModel]) in
            completion(cocktails)
        }
    }
    
    func fetchCocktailDetail(id : String, completion: @escaping (CocktailDetailModel?) -> Void) {
        networkCocktails.get("\(id)") { (cocktail: CocktailDetailModel?) in
            completion(cocktail)
        }
    }
    
    
}
