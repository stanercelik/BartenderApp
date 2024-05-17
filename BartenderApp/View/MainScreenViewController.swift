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
    let favoritesButton = UIButton()
    let searchBar = UISearchBar()
    let coctailsCollectionView: UICollectionView = {
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
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        favoritesButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoritesButton.tintColor = .black
        favoritesButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(favoritesButton)
    }
    
    @objc func saveButtonTapped() {
        let favoritesVC = FavoritesViewController()
            navigationController?.pushViewController(favoritesVC, animated: true)
    }

    func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search a cocktail"
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.sizeToFit()

        view.addSubview(searchBar)
    }

    func configureCollectionView() {
        coctailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coctailsCollectionView)
    }
                      
    
    // MARK: - Constraints

    private func setupConstraints() {
            // Title label constraints
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: favoritesButton.leadingAnchor)
                
            ])

            // Favorites button constraints
            NSLayoutConstraint.activate([
                favoritesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                favoritesButton.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -16),
                favoritesButton.widthAnchor.constraint(equalToConstant: 32)
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
            
            // FavoritesButton constraints
        NSLayoutConstraint.activate([
            favoritesButton.imageView!.heightAnchor.constraint(equalToConstant: 24),
            favoritesButton.imageView!.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}


// MARK: CollectionView
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktail: CocktailModel
        if isFiltering {
            cocktail = filteredCocktailList[indexPath.item]
        } else {
            cocktail = cocktailList[indexPath.item]
        }
        let detailVC = CocktailDetailViewController()
        detailVC.cocktailID = cocktail.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


// MARK: SearchBar
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

