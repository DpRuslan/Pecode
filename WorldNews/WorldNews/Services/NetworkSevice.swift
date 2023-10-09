//
//  NetworkSevice.swift
// 

import Foundation
import UIKit.UIImage

// MARK: Structs for comfortable use after receiving parsed data

struct ArticlesData {
    let author: String
    let title: String
    let description: String
    let url: String?
    let urlToImage: String?
    let sourceName: String
    var favoriteImage: UIImage
    
    init(articles: ArticlesResponse.Article, favoriteImage: UIImage) {
        self.author = articles.author ?? "None"
        self.title = articles.title ?? "None"
        self.description = articles.description ?? "None"
        self.url = articles.url
        self.urlToImage = articles.urlToImage
        self.sourceName = articles.source.name ?? "None"
        self.favoriteImage = favoriteImage
    }
    
// MARK: init for populating dataSource in FavoriteViewController
    
    init(favoriteArticle: FavoriteArticle) {
        self.author = favoriteArticle.author!
        self.title = favoriteArticle.title!
        self.description = favoriteArticle.newsDescription!
        self.url = favoriteArticle.url!
        self.urlToImage = favoriteArticle.urlToImage
        self.sourceName = favoriteArticle.sourceName!
        self.favoriteImage = favoriteArticle.isFavorite ? Model.favoriteImage : Model.unfavoriteImage
    }
}

struct FiltersData {
    let id: String?
    let name: String
    let category: String?
    let country: String?
    var chosen: Bool = false
    
    init(filters: SourcesResponse.Sources) {
        self.id = filters.id ?? "None"
        self.name = filters.name ?? "None"
        self.category = filters.category ?? "None"
        self.country = filters.country ?? "None"
    }
    
    init(id: String?, name: String, category: String?, country: String?) {
        self.id = id
        self.name = name
        self.category = category
        self.country = country
    }
}

final class NetworkService {
    var articles: ArticlesResponse?
    var articlesData: [ArticlesData] = []
    
    var sources: SourcesResponse?
    var sourcesData: [FiltersData] = []
    
    let placeholderImage = Model.placeholderImage
    
    let dispatchGroup = DispatchGroup()
    let dataQueue = DispatchQueue(label: "com.example.dataQueue")
    
    let storageService = StorageService()
    
// MARK: Doing requests
    
    func articlesRequest(endpoint: String, completion: @escaping(Status) -> Void) {
        dispatchGroup.enter()
        APIManager.shared.request(endpoint: endpoint, method: .GET) {[weak self] result in
            guard let self = self else { return }
            
            ParseService.shared.parseResponse(res: result, myData: &self.articles, decodeStruct: ArticlesResponse.self) { status in
                switch status {
                case .success:
                    self.dataQueue.async {
                        if self.articles!.articles.isEmpty {
                            self.dispatchGroup.leave()
                            completion(.empty)
                        } else {
                            for i in self.articles!.articles {
                                self.articlesData.append(
                                    ArticlesData(
                                        articles: i,
                                        favoriteImage: self.storageService.checkFavoriteImage(articleId: i.url)
                                    )
                                )
                            }
                            
                            self.dispatchGroup.leave()
                            completion(status)
                        }
                    }
                default:
                    self.dispatchGroup.leave()
                    completion(status)
                }
            }
        }
    }
    
    func sourcesRequest(endpoint: String, completion: @escaping(Status) -> Void) {
        dispatchGroup.enter()
        APIManager.shared.request(endpoint: endpoint, method: .GET) {[weak self] result in
            guard let self = self else { return }
            
            ParseService.shared.parseResponse(res: result, myData: &self.sources, decodeStruct: SourcesResponse.self) { status in
                switch status {
                case .success:
                    self.dataQueue.async {
                        for i in self.sources!.sources {
                            self.sourcesData.append(FiltersData(filters: i))
                        }
                        self.dispatchGroup.leave()
                        completion(status)
                        
                    }
                default:
                    self.dispatchGroup.leave()
                    completion(status)
                }
            }
        }
    }
}
