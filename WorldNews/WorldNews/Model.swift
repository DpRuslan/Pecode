//
//  Model.swift
//

import Foundation
import UIKit.UIImage

struct Model {
    static let appName = "World News"
    static let filterImage = UIImage(named: "filterImage")!
    static let favoriteImage = UIImage(named: "favoriteImage")!
    static let unfavoriteImage = UIImage(named: "unfavoriteImage")!
    static let categoriesFilter = "Categories"
    static let countriesFilter = "Countries"
    static let sourcesFilter = "Sources"
    static let clearFilter = "Clear filter"
    static let placeholderImage = UIImage(named: "placeholder")!
    static let checkmarkImage = UIImage(named: "checkmark")!
    static let searchPlaceholder = "Search news"
    static let filters = "Filters"
    static let favoriteNews = "Favorite News"
    
    static let filtersDataSource: [(String, String?, String)] = [
        ("Category", nil, "category="),
        ("Country", nil, "country="),
        ("Source", nil, "soruces="),
    ]
    
    static let categoriesDataSource = [
        ("business", false),
        ("entertainment", false),
        ("general", false),
        ("health", false),
        ("science", false),
        ("sports", false),
        ("technology", false)
    ]
    
    static let countriesTwoLettersDataSource = [
        ("ae", "United Arab Emirates", false),
        ("ar", "Argentina", false),
        ("at", "Austria", false),
        ("au", "Australia", false),
        ("be", "Belgium", false),
        ("bg", "Bulgaria", false),
        ("br", "Brazil", false),
        ("ca", "Canada", false),
        ("ch", "Switzerland", false),
        ("cn", "China", false),
        ("co", "Colombia", false),
        ("cu", "Cuba", false),
        ("cz", "Czech Republic", false),
        ("de", "Germany", false),
        ("eg", "Egypt", false),
        ("fr", "France", false),
        ("gb", "United Kingdom", false),
        ("gr", "Greece", false),
        ("hk", "Hong Kong", false),
        ("hu", "Hungary", false),
        ("id", "Indonesia", false),
        ("ie", "Ireland", false),
        ("il", "Israel", false),
        ("in", "India", false),
        ("it", "Italy", false),
        ("jp", "Japan", false),
        ("kr", "South Korea", false),
        ("lt", "Lithuania", false),
        ("lu", "Luxembourg", false),
        ("lv", "Latvia", false),
        ("ma", "Morocco", false),
        ("mx", "Mexico", false),
        ("my", "Malaysia", false),
        ("ng", "Nigeria", false),
        ("nl", "Netherlands", false),
        ("no", "Norway", false),
        ("nz", "New Zealand", false),
        ("ph", "Philippines", false),
        ("pl", "Poland", false),
        ("pt", "Portugal", false),
        ("ro", "Romania", false),
        ("rs", "Serbia", false),
        ("ru", "Russia", false),
        ("sa", "Saudi Arabia", false),
        ("se", "Sweden", false),
        ("sg", "Singapore", false),
        ("sk", "Slovakia", false),
        ("th", "Thailand", false),
        ("tr", "Turkey", false),
        ("tw", "Taiwan", false),
        ("ua", "Ukraine", false),
        ("us", "United States", false),
        ("ve", "Venezuela", false),
        ("za", "South Africa", false)
    ]
}
