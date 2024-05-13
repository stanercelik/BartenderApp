//
//  ViewController.swift
//  BartenderApp
//
//  Created by Taner Çelik on 12.05.2024.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    let networking = Networking()
    let viewModel = MainScreenViewModel()
    
    var cocktailList : [CocktailModel] = []
    var filteredCocktailList : [CocktailModel] = []
    var isFiltering: Bool = false
    
    let titleLabel = UILabel()
    let addFavoritesButtonImage = UIImageView()
    let searchBar = UISearchBar()
    let coctailsCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout() // Create a layout
            layout.scrollDirection = .vertical // Set scroll direction
            layout.minimumLineSpacing = 8 // Set minimum spacing between rows
            layout.minimumInteritemSpacing = 8 // Set minimum spacing between items in a row
            let itemWidth = (UIScreen.main.bounds.width - 48) / 3
            layout.itemSize = CGSize(width: itemWidth, height: 150)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // Initialize with the layout
            collectionView.register(CocktailCollectionViewCell.self, forCellWithReuseIdentifier: "CocktailCollectionViewCell") // Register a cell class
            return collectionView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground

        configureLabel()
        configureSearchBar()
        configureFavoritesButton()
        configureCollectionView()
        setupConstraints()

        coctailsCollectionView.delegate = self
        coctailsCollectionView.dataSource = self
        
        self.filteredCocktailList = cocktailList
        
        searchBar.delegate = self
        
        fetchCocktails()
    }
    
    func fetchCocktails() {
        networking.fetchCocktails { [weak self] models in
            self?.cocktailList = models
            
            DispatchQueue.main.async {
                self?.coctailsCollectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Configures

    func configureLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Cocktails"
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)

        view.addSubview(titleLabel)
    }

    func configureFavoritesButton() {
        addFavoritesButtonImage.translatesAutoresizingMaskIntoConstraints = false
        addFavoritesButtonImage.image = UIImage(systemName: "bookmark")
        addFavoritesButtonImage.tintColor = .black

        view.addSubview(addFavoritesButtonImage)
    }

    func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search a cocktail"
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.sizeToFit()

        view.addSubview(searchBar)
    }

    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        coctailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coctailsCollectionView)
    }
                      
    
    // MARK: - Constraints

    private func setupConstraints() {
            // Title label constraints
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: addFavoritesButtonImage.leadingAnchor)
                
            ])

            // Favorites button constraints
            NSLayoutConstraint.activate([
                addFavoritesButtonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                addFavoritesButtonImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                addFavoritesButtonImage.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -16),
                addFavoritesButtonImage.widthAnchor.constraint(equalToConstant: 32)
            ])

            // Search bar constraints
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                searchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                searchBar.heightAnchor.constraint(equalToConstant: 44)
            ])

            // Collection view constraints
            NSLayoutConstraint.activate([
                coctailsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
                coctailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                coctailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                coctailsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

}


extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCocktailList.count
        }
            return cocktailList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CocktailCollectionViewCell", for: indexPath) as! CocktailCollectionViewCell
        
        if isFiltering {
            let cocktailModel = filteredCocktailList[indexPath.item]
            cell.setup(model: cocktailModel)
        } else {
            let cocktailModel = cocktailList[indexPath.item]
            cell.setup(model: cocktailModel)
        }
        return cell
    }
}


extension MainScreenViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isFiltering = true
        
        if searchText.isEmpty {
            filteredCocktailList = cocktailList
        } else {
            filteredCocktailList = cocktailList.filter { cocktail in
                cocktail.title.lowercased().contains(searchText.lowercased())
            }
        }
        coctailsCollectionView.reloadData()
    }
}

