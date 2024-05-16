//
//  CocktailCollectionViewCell.swift
//  BartenderApp
//
//  Created by Taner Çelik on 12.05.2024.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {

    let viewModel = MainScreenViewModel()
    
    let cocktailView = UIView()
    var cocktailImage = UIImageView()
    let gradientView = UIView()
    let titleLabel = UILabel()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {
        configureView()
        configureImage()
        configureTitle()
        configureGradient()
        addShadowEffect()

        setupConstraints()
    }
    
    
    // MARK: - Configures
    private func configureView(){
        cocktailView.translatesAutoresizingMaskIntoConstraints = false
        cocktailView.layer.cornerRadius = 8
        cocktailView.clipsToBounds = true
        contentView.addSubview(cocktailView)
    }
    
    
    private func configureImage(){
        cocktailImage.translatesAutoresizingMaskIntoConstraints = false
        cocktailImage.clipsToBounds = true
        cocktailView.addSubview(cocktailImage)
    }
    
    private func configureGradient(){
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientView.layer.addSublayer(gradientLayer)
        cocktailView.addSubview(gradientView)
    }
    
    private func configureTitle(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .white
        
        cocktailView.addSubview(titleLabel)
    }
    
    private func addShadowEffect() {
            cocktailView.layer.shadowColor = UIColor.black.cgColor
            cocktailView.layer.shadowOpacity = 1
            cocktailView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cocktailView.layer.shadowRadius = 4
            cocktailView.layer.shouldRasterize = true
            cocktailView.layer.rasterizationScale = UIScreen.main.scale
        }
    
    
    // MARK: - Constraints
    func setupConstraints(){
        
        // View Constraints
        NSLayoutConstraint.activate([
            cocktailView.topAnchor.constraint(equalTo: topAnchor),
            cocktailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cocktailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cocktailView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        // Image Constrains
        NSLayoutConstraint.activate([
            cocktailImage.topAnchor.constraint(equalTo: cocktailView.topAnchor),
            cocktailImage.leadingAnchor.constraint(equalTo: cocktailView.leadingAnchor),
            cocktailImage.trailingAnchor.constraint(equalTo: cocktailView.trailingAnchor),
            cocktailImage.bottomAnchor.constraint(equalTo: cocktailView.bottomAnchor),
        ])
        
        // Title Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cocktailImage.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: cocktailImage.bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        // GradientView Constraints
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: cocktailView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cocktailView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cocktailView.bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: cocktailView.topAnchor),
        ])
    }
    
    
    // MARK: - Setup Func
    func setup(model: CocktailModel) {
        
        cocktailImage = viewModel.downloadImage(url: model.image, cocktailImage: self.cocktailImage)
        titleLabel.text = model.title
    }
    
}
