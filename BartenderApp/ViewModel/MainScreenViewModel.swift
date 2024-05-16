//
//  MainScreenViewModel.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import Foundation
import UIKit
import SDWebImage

class MainScreenViewModel {
    
    func downloadImage(url: URL, cocktailImage : UIImageView) -> UIImageView {
        cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { _, error, _, _ in
            if let error = error {
                print("Error downloading image: \(error)")
            }
        }
        
        return cocktailImage
    }
}

// KingFisher
// SDImages
