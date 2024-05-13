//
//  CocktailDetailViewController.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import UIKit

class CocktailDetailViewController: UIViewController {
    let viewModel = MainScreenViewModel()
    let networking = Networking()
    var cocktailID : String?
    var cocktail : CocktailDetailModel?
    let titleLabel =  UILabel()
    let difficulty = UILabel()
    let portion = UILabel()
    let time = UILabel()
    let cocktailDescription = UILabel()
    let ingredients = UILabel()
    let method = UILabel()
    let image = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        
        configureTitle()
        configureImage()
        configureTime()
        configurePortion()
        configureMethod()
        configureDifficulty()
        configureDescription()
        configureIngredients()
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        networking.fetchCocktailDetail(id: cocktailID ?? "", completion: { [weak self] model in
            self?.cocktail = model
            
            DispatchQueue.main.async {
                self?.titleLabel.text = model?.title
            }
        })
    }
    
    //MARK: Configures
    func configureTitle(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = cocktail?.title
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    func configureImage(){
        
    }
    
    func configureDifficulty(){
        
    }
    
    func configurePortion(){
        
    }
    
    func configureTime(){
        
    }
    
    func configureDescription(){
        
    }
    
    func configureIngredients(){
        
    }
    
    func configureMethod(){
        
    }
    
    
    
    //MARK: Constraints
    func setConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    
    
    
}
