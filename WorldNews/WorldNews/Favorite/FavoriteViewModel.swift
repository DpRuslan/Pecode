//
//  FavoriteViewModel.swift
//  

import Foundation
import CoreData
import Combine

final class FavoriteViewModel: NSObject {
    weak var coordinator: FavoriteCoordinatorProtocol?
    
    let storageService = StorageService()
    let favoriteNews = Model.favoriteNews
    
    private var changesMade = false
    
    private var dataSource: [FavoriteArticle]? = []
    lazy var favoriteNewsResultsController = storageService.makeFetchedResultsController()
    
    private let eventSubject = PassthroughSubject<Void, Never>()
    
    var eventPubisher: AnyPublisher<Void, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func eventOccured() {
        eventSubject.send()
    }
    
    override init() {
        super.init()
        dataSource = favoriteNewsResultsController.fetchedObjects
        favoriteNewsResultsController.delegate = self
    }
    
    func numberOf() -> Int {
        dataSource?.count ?? 0
    }
    
    func articleAt(at index: Int) -> FavoriteArticle {
        return dataSource![index]
    }
    
    func didSelectArticleAt(at index: Int) {
        coordinator?.detailNews(urlString: dataSource![index].url!)
    }
    
    func backVC() {
        coordinator?.backVC(value: changesMade)
    }
}

extension FavoriteViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataSource = favoriteNewsResultsController.fetchedObjects
        changesMade = true
        eventOccured()
    }
}

