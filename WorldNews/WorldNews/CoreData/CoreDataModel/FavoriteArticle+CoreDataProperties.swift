//
//  FavoriteArticle+CoreDataProperties.swift
//  

import Foundation
import CoreData


extension FavoriteArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArticle> {
        return NSFetchRequest<FavoriteArticle>(entityName: "FavoriteArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var isFavorite: Bool

}

extension FavoriteArticle : Identifiable {

}
