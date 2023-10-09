//
//  MainViewModel.swift
//

import Foundation
import UIKit.UIImage
import Combine

final class MainViewModel {
    enum Event {
        case update
        case error(errorDescr: String)
        case loading
        case endLoading
    }
    
    weak var coordinator: MainCoordinatorProtocol?
    
    let appName = Model.appName
    let filterImage = Model.filterImage
    let favoriteImage = Model.favoriteImage
    let searchPlaceholder = Model.searchPlaceholder
    let endpoint = URLExtension.articles.rawValue
    
    var pageNumber = 1
    var planAllowsMoreData = true
    var isLoadingData = false
    var isRefreshing = false
    var q = URLExtension.world.rawValue
    
    let networkService = NetworkService()
    
    var dataSource: [ArticlesData] = []
    
// MARK: Combine(for notifying controller)
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var eventPubisher: AnyPublisher<Event, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func eventOccured(event: Event) {
        eventSubject.send(event)
    }
    
// MARK: ArticlesRequest
    
    func articlesRequest(q: String, endpoint: String) {
        if !dataSource.isEmpty && isLoadingData {
            self.eventOccured(event: .update)
        }
        
        if dataSource.isEmpty && !isRefreshing {
            eventOccured(event: .loading)
        }
        
        networkService.articlesRequest(endpoint: endpoint + q + URLExtension.page.rawValue + "\(pageNumber)") { [weak self] status in
            switch status {
            case .success:
                self?.dataSource = self?.networkService.articlesData ?? []
                self?.eventOccured(event: .update)
            case .failure(let error):
                if error == CustomError.requestFailed(426) || error == CustomError.requestFailed(429) {
                    self?.planAllowsMoreData = false
                }
                self?.eventOccured(event: .error(errorDescr: error.localizedDescription))
            case .empty:
                self?.eventOccured(event: .error(errorDescr: CustomError.empty.localizedDescription))
            }
            
            if !self!.dataSource.isEmpty && !self!.isLoadingData {
                self?.eventOccured(event: .endLoading)
            }
            
            self?.isLoadingData = false
            self?.isRefreshing = false
            self?.eventOccured(event: .update)
        }
    }
    
    func articlesNumberOf() -> Int {
        dataSource.count
    }
    
    func articleAt(at index: Int) -> ArticlesData {
        dataSource[index]
    }
    
    func didSelectArticleAt(at index: Int) {
        coordinator?.detailNews(urlString: dataSource[index].url!)
    }
    
    func filterVC() {
        coordinator?.filterVC()
    }
    
    func favoriteVC() {
        coordinator?.favoriteVC()
    }
    
    func resetAll() {
        dataSource = []
        networkService.articlesData = []
        pageNumber = 1
        planAllowsMoreData = true
    }
}
