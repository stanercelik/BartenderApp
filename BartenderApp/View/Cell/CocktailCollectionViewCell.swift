//
//  CocktailCollectionViewCell.swift
//  BartenderApp
//
//  Created by Taner Çelik on 12.05.2024.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {

    let cocktailView: UIView = {
        let cocktailView = UIView()
        cocktailView.backgroundColor = .systemRed
        return cocktailView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {
        contentView.addSubview(cocktailView)


        cocktailView.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            cocktailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cocktailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cocktailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cocktailView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }

}
