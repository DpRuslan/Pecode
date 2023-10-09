//
//  URLExtension.swift
//

import Foundation

enum URLExtension: String {
    case apiKey = "e946bd8a4c7d4943915b29f45502e2f2"
    case baseURL = "https://newsapi.org/v2"
    case page = "&page="
    
    case articles = "/everything?publishedAt&pageSize=10&q="
    case world = "World"
    
    case sources = "/top-headlines/sources?"
    
    case filteredByCategory = "/top-headlines?pageSize=10&category="
    case filteredByCountry = "/top-headlines?pageSize=10&country="
    case filteredBySource = "/top-headlines?pageSize=10&sources="
}
