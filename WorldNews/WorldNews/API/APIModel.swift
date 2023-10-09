//
//  APIModel.swift
//

import Foundation

// MARK: Parsing Articles

struct ArticlesResponse: Decodable {
    let articles: [Article]
    
    struct Article: Decodable {
        let author: String?
        let title: String?
        let description: String?
        let url: String?
        let urlToImage: String?
        let source: Source
        
        struct Source: Decodable {
            let name: String?
        }
    }
}

// MARK: Parsing Sources

struct SourcesResponse: Decodable {
    let sources: [Sources]
    
    struct Sources: Decodable {
        let id: String?
        let name: String?
        let category: String?
        let country: String?
    }
}
