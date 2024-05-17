//
//  FavouritesViewController.swift
//  BartenderApp
//
//  Created by Taner Çelik on 17.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    var favoriteCocktails: [CocktailDetailModel] = []
    let cocktailsCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            let itemWidth = (UIScreen.main.bounds.width - 48) / 3
            layout.itemSize = CGSize(width: itemWidth, height: 150)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(CocktailCollectionViewCell.self, forCellWithReuseIdentifier: "CocktailCollectionViewCell")
            return collectionView
        }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
        navigationItem.backBarButtonItem?.tintColor = .black

        cocktailsCollectionView.delegate = self
        cocktailsCollectionView.dataSource = self
        
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteCocktails = CoreDataManager.shared.getFavoriteCocktails()
        cocktailsCollectionView.reloadData()
    }
    
    
    //MARK: Configure
    func configureCollectionView(){
        view.addSubview(cocktailsCollectionView)
        cocktailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cocktailsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:16),
            cocktailsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cocktailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            cocktailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
}

// MARK: CollectionView
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteCocktails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CocktailCollectionViewCell", for: indexPath) as! CocktailCollectionViewCell
            let cocktailModel = favoriteCocktails[indexPath.item]
            cell.setup(model: cocktailModel)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail = favoriteCocktails[indexPath.row]
        let detailVC = CocktailDetailViewController()
        detailVC.cocktailID = cocktail.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

