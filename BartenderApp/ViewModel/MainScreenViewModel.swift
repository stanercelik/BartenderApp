//
//  MainScreenViewModel.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import Foundation
import UIKit

class MainScreenViewModel {
    
    func downloadImage(model: CocktailModel, cocktailImage : UIImageView) {
        let imageUrl = model.image
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                cocktailImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
