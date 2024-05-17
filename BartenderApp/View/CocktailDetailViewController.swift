//
//  CocktailDetailViewController.swift
//  BartenderApp
//
//  Created by Taner Çelik on 13.05.2024.
//

import UIKit

class CocktailDetailViewController: UIViewController {
    let cocktailDetailModel = CocktailDetailModel(
      id: "45",
      title: "Mojitodadlknaskdnalsdnşlasçdada dasds",
      difficulty: "Easy",
      portion: "Serves 6-8",
      time: "Hands-on time 5 min",
      description: "Get into the spirit of summer with this classic Italian recipe. Chilled prosecco and Aperol come together to create the beloved Aperol spritz.",
      ingredients: [
        "750ml bottle of prosecco",
        "Bag of ice",
        "Bottle of Aperol",
        "Bottle of soda water",
        "Slice of orange"
      ],
      method: [
        ["Step 1": "Chill the bottle of prosecco and Aperol in the fridge."],
        ["Step 2": "Fill 6 or 8 wine glasses or tall tumblers with a couple of ice cubes and roughly three parts prosecco to one part Aperol."],
        ["Step 3": "Add a splash of soda water and a slice of orange. Serve straightaway so that the fizz stays lively."]
      ],
      image: URL(string: "https://apipics.s3.amazonaws.com/coctails_api/25.jpg")!
    )
    
    let viewModel = MainScreenViewModel()
    let networking = Networking()
    var cocktailID : String?
    var cocktail : CocktailDetailModel?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let saveButton = UIButton()
    let titleLabel =  UILabel()
    let difficulty = UILabel()
    let portion = UILabel()
    let time = UILabel()
    let descriptionTitle = UILabel()
    let cocktailDescription = UILabel()
    let ingredientsTitle = UILabel()
    let ingredients = UILabel()
    let methodTitle = UILabel()
    var method = UILabel()
    var image = UIImageView()
    
    let topView = UIView()
    let imageBottomView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cocktail Detail"
        navigationItem.backBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .appBackground
        
        configureTopView()
        configureScrollView()
        
        configureContentView()
        configureImage()
        
        configureTitle()
        configureTime()
        configurePortion()
        configureDifficulty()
        configureDescription()
        configureIngredients()
        configureMethod()
        configureImageBottomView()
        configureSaveButtonImage()
        
        setConstraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        configureGradientLayer()
        imageBottomViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let cocktailID = cocktailID else {
                print("No cocktail ID provided")
                return
            }
        
        networking.fetchCocktailDetail(id: cocktailID, completion: { [weak self] model in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard let model = model else {
                    print("Failed to fetch cocktail details")
                    return
                }
                self.cocktail = model

                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        })
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        guard let cocktailID = cocktailID else { return }
        let isFavorite = CoreDataManager.shared.isFavorite(cocktailID: cocktailID)
        saveButton.isSelected = isFavorite
        let buttonImageName = isFavorite ? "bookmark.fill" : "bookmark"
        saveButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    func updateUI() {
        guard let cocktail = self.cocktail else { return }
        
        self.titleLabel.text = cocktail.title
        self.image = self.viewModel.downloadImage(url: cocktail.image, cocktailImage: self.image)
        self.difficulty.text = cocktail.difficulty
        self.cocktailDescription.text = cocktail.description
        self.portion.text = cocktail.portion
        self.time.text = cocktail.time
        self.ingredients.text = self.createBulletListLabel(cocktail.ingredients)
        self.method.text = self.createStepLabel(cocktail.method)
    }
    
    // MARK: Text Formatters
    func createBulletListLabel(_ list : [String]) -> String {
        return list.enumerated().map { index, item in
            if index == 0 {
                "• \(item)"
            } else {
                "\n• \(item)"
            }
        }.joined()
    }
    
    func createStepLabel(_ steps : [[String: String]]) -> String {
        var formattedMethodText = ""
        for (index, step) in steps.enumerated() {
            let stepNumber = "Step \(index + 1):"
            let stepDescription = step.values.first!
            formattedMethodText += "\(stepNumber) \(stepDescription)\n\n"
        }
        return formattedMethodText
    }
    
    
    //MARK: Configures
    func configureScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .appBackground

        view.addSubview(scrollView)
    }
    
    func configureContentView(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func configureTopView(){
        topView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topView)
    }
    
    func configureGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = image.bounds
        image.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func configureImageBottomView(){
        imageBottomView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(imageBottomView)
    }
    
    func configureTitle(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.text = cocktail?.title
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .left
        imageBottomView.addSubview(titleLabel)
        
        
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitle.text = "Description"
        descriptionTitle.textColor = .black
        descriptionTitle.font = .systemFont(ofSize: 28, weight: .bold)
        descriptionTitle.textAlignment = .left
        contentView.addSubview(descriptionTitle)
        
        ingredientsTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitle.text = "Ingredients"
        ingredientsTitle.textColor = .black
        ingredientsTitle.font = .systemFont(ofSize: 28, weight: .bold)
        ingredientsTitle.textAlignment = .left
        contentView.addSubview(ingredientsTitle)
        
        methodTitle.translatesAutoresizingMaskIntoConstraints = false
        methodTitle.text = "Method"
        methodTitle.textColor = .black
        methodTitle.font = .systemFont(ofSize: 28, weight: .bold)
        methodTitle.textAlignment = .left
        contentView.addSubview(methodTitle)
    }
    
    func configureImage(){
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        topView.addSubview(image)
    }
    
    func configureDifficulty(){
        difficulty.translatesAutoresizingMaskIntoConstraints = false
        difficulty.textAlignment = .left
        difficulty.textColor = .white
        difficulty.numberOfLines = 1
        difficulty.font = .systemFont(ofSize: 17, weight: .semibold)
        imageBottomView.addSubview(difficulty)
    }
    
    func configurePortion(){
        portion.translatesAutoresizingMaskIntoConstraints = false
        portion.textAlignment = .right
        portion.textColor = .white
        portion.numberOfLines = 1
        portion.font = .systemFont(ofSize: 17, weight: .semibold)
        imageBottomView.addSubview(portion)
    }
    
    func configureTime(){
        time.translatesAutoresizingMaskIntoConstraints = false
        time.textAlignment = .right
        time.textColor = .white
        time.numberOfLines = 1
        time.font = .systemFont(ofSize: 17, weight: .semibold)
        imageBottomView.addSubview(time)
    }
    
    func configureDescription(){
        cocktailDescription.translatesAutoresizingMaskIntoConstraints = false
        cocktailDescription.textAlignment = .justified
        cocktailDescription.textColor = .black
        cocktailDescription.font = .systemFont(ofSize: 17, weight: .regular)
        cocktailDescription.numberOfLines = 0
        contentView.addSubview(cocktailDescription)
    }
    
    func configureIngredients(){
        ingredients.translatesAutoresizingMaskIntoConstraints = false
        ingredients.textAlignment = .left
        ingredients.textColor = .black
        ingredients.numberOfLines = 0
        ingredients.font = .systemFont(ofSize: 17, weight: .regular)
        contentView.addSubview(ingredients)
    }
    
    func configureMethod(){
        method.translatesAutoresizingMaskIntoConstraints = false
        method.textAlignment = .left
        method.textColor = .black
        method.numberOfLines = 0
        method.font = .systemFont(ofSize: 17, weight: .regular)
        contentView.addSubview(method)
    }
    
    func configureSaveButtonImage(){
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        saveButton.tintColor = .white
        topView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Add shadow to buttonImageView
         let buttonImageViewLayer = saveButton.imageView!.layer
         buttonImageViewLayer.shadowColor = UIColor.black.cgColor
         buttonImageViewLayer.shadowOffset = CGSize(width: 5, height: 5)
         buttonImageViewLayer.shadowRadius = 5.0
         buttonImageViewLayer.shadowOpacity = 0.5
         saveButton.layer.addSublayer(buttonImageViewLayer)
    }
    
    @objc func saveButtonTapped() {
        guard let cocktail = self.cocktail else { return }
        saveButton.isSelected.toggle()
        if saveButton.isSelected {
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            CoreDataManager.shared.saveFavoriteCocktail(cocktail)
        } else {
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            CoreDataManager.shared.removeFavoriteCocktail(cocktail.id)
        }
    }
    
    
    // MARK: Constraints
    func setConstraints(){
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentView Constraints
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        // TopView Constraints
        NSLayoutConstraint.activate([
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
        
        // Image Constraints
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            image.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            image.topAnchor.constraint(equalTo: topView.topAnchor),
            image.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
        
        // Title Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageBottomView.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: difficulty.topAnchor, constant: -4),
            titleLabel.widthAnchor.constraint(equalTo: imageBottomView.widthAnchor, multiplier: 0.5)
        ])
        
        // Difficulty Constraints
        NSLayoutConstraint.activate([
               difficulty.leadingAnchor.constraint(equalTo: imageBottomView.leadingAnchor, constant: 8),
               difficulty.bottomAnchor.constraint(equalTo: imageBottomView.bottomAnchor, constant: -8),
               difficulty.widthAnchor.constraint(equalTo: imageBottomView.widthAnchor, multiplier: 0.4)
           ])
        
        // Time Constraints
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 42),
            time.trailingAnchor.constraint(equalTo: imageBottomView.trailingAnchor, constant: -8),
            //time.topAnchor.constraint(equalTo: imageBottomView.topAnchor, constant: 8),
            time.bottomAnchor.constraint(equalTo: portion.topAnchor, constant: -4)
           ])
        
        
        // Portion Constraints
        NSLayoutConstraint.activate([
               portion.trailingAnchor.constraint(equalTo: imageBottomView.trailingAnchor, constant: -8),
               portion.bottomAnchor.constraint(equalTo: imageBottomView.bottomAnchor, constant: -8)
           ])
        
        // DescriptionTitle Constraints
        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
            descriptionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // cocktailDescription Constraints
        NSLayoutConstraint.activate([
            cocktailDescription.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 8),
            cocktailDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cocktailDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // saveButton Constraints
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            
        ])
        
        // saveButtonImageView Constraints
        NSLayoutConstraint.activate([
            saveButton.imageView!.heightAnchor.constraint(equalToConstant: 42),
            saveButton.imageView!.widthAnchor.constraint(equalToConstant: 42)
        ])
        
        // ingredientsTitle Constraints
        NSLayoutConstraint.activate([
            ingredientsTitle.topAnchor.constraint(equalTo: cocktailDescription.bottomAnchor, constant: 16),
            ingredientsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ingredientsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // ingredients Constraints
        NSLayoutConstraint.activate([
            ingredients.topAnchor.constraint(equalTo: ingredientsTitle.bottomAnchor, constant: 8),
            ingredients.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ingredients.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // methodTitle Constraints
        NSLayoutConstraint.activate([
            methodTitle.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 16),
            methodTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            methodTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // method Constraints
        NSLayoutConstraint.activate([
            method.topAnchor.constraint(equalTo: methodTitle.bottomAnchor, constant: 8),
            method.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            method.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            method.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // ImageBottomView Constraints
    func imageBottomViewConstraints() {
        NSLayoutConstraint.activate([
            imageBottomView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            imageBottomView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            imageBottomView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
        ])
    }
    
    
}
