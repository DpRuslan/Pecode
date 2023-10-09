//
//  StorageService.swift
//

import Foundation
import UIKit.UIImage
import CoreData

final class StorageService {
    let managedContext = AppDelegate.coreDataStack.managedContext
    let request = FavoriteArticle.fetchRequest()
    
// MARK: Save favorite news to CoreData
    
    func saveToCoreData(article: ArticlesData) {
        let newFavoriteArticle = FavoriteArticle(context: managedContext)
        newFavoriteArticle.id = article.url
        newFavoriteArticle.url = article.url
        newFavoriteArticle.author = article.author
        newFavoriteArticle.sourceName = article.sourceName
        newFavoriteArticle.title = article.title
        newFavoriteArticle.urlToImage = article.urlToImage
        newFavoriteArticle.newsDescription = article.description
        newFavoriteArticle.isFavorite = true
        
        AppDelegate.coreDataStack.saveContext()
    }
    
// MARK: Delete favorite news from CoreData
    
    func deleteFromCoreData(articleId: String) {
        do {
            let articles = try managedContext.fetch(request)
            if let articleToDelete = articles.first(where: { $0.id == articleId }) {
                managedContext.delete(articleToDelete)
                AppDelegate.coreDataStack.saveContext()
            }
        } catch {
            print("Error deleting")
        }
    }
    
// MARK: Check if news are favorite (CoreData fetching)
    
    func checkFavoriteImage(articleId: String?) -> UIImage {
        do {
            let articles = try managedContext.fetch(request)
            if let _ = articles.first(where:{ $0.id == articleId }) {
                return Model.favoriteImage
            } else {
                return Model.unfavoriteImage
            }
        } catch {
            print("Error detecting")
        }
        
        return Model.unfavoriteImage
    }
    
// MARK: makeFetchedResultsController() and populate this controller with data
    
    func makeFetchedResultsController() -> NSFetchedResultsController<FavoriteArticle> {
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        try? controller.performFetch()
        return controller
    }
}
