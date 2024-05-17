//
//  CoreDataManager.swift
//  BartenderApp
//
//  Created by Taner Çelik on 17.05.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BartenderApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveFavoriteCocktail(_ cocktail: CocktailDetailModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Cocktail", in: context)!
        let cocktailObject = NSManagedObject(entity: entity, insertInto: context)
        cocktailObject.setValue(cocktail.id, forKey: "id")
        cocktailObject.setValue(cocktail.title, forKey: "title")
        cocktailObject.setValue(cocktail.difficulty, forKey: "difficulty")
        cocktailObject.setValue(cocktail.portion, forKey: "portion")
        cocktailObject.setValue(cocktail.time, forKey: "time")
        cocktailObject.setValue(cocktail.description, forKey: "cocktailDescription")
        cocktailObject.setValue(cocktail.ingredients, forKey: "ingredients")
        cocktailObject.setValue(cocktail.method, forKey: "method")
        cocktailObject.setValue(cocktail.image.absoluteString, forKey: "imageURL")
        saveContext()
    }

    func removeFavoriteCocktail(_ cocktailID: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cocktail")
        fetchRequest.predicate = NSPredicate(format: "id == %@", cocktailID)
        do {
            let result = try context.fetch(fetchRequest)
            if let objectToDelete = result.first as? NSManagedObject {
                context.delete(objectToDelete)
                saveContext()
            }
        } catch {
            print("Failed to delete cocktail: \(error)")
        }
    }

    func getFavoriteCocktails() -> [CocktailDetailModel] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cocktail")
        do {
            let result = try context.fetch(fetchRequest)
            return result.compactMap {
                guard let cocktail = $0 as? NSManagedObject else { return nil }
                return CocktailDetailModel(
                    id: cocktail.value(forKey: "id") as! String,
                    title: cocktail.value(forKey: "title") as! String,
                    difficulty: cocktail.value(forKey: "difficulty") as! String,
                    portion: cocktail.value(forKey: "portion") as! String,
                    time: cocktail.value(forKey: "time") as! String,
                    description: cocktail.value(forKey: "cocktailDescription") as! String,
                    ingredients: cocktail.value(forKey: "ingredients") as! [String],
                    method: cocktail.value(forKey: "method") as! [[String: String]],
                    image: URL(string: cocktail.value(forKey: "imageURL") as! String)!
                )
            }
        } catch {
            print("Failed to fetch cocktails: \(error)")
            return []
        }
    }
    
    func isFavorite(cocktailID: String) -> Bool {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cocktail")
            fetchRequest.predicate = NSPredicate(format: "id == %@", cocktailID)
            do {
                let count = try context.count(for: fetchRequest)
                return count > 0
            } catch {
                print("Failed to fetch cocktail: \(error)")
                return false
            }
        }
}
