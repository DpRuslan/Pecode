//
//  FilterViewModel.swift
//

import Foundation
import Combine

final class FilterViewModel {
    enum Event {
        case error(errorDescr: String)
        case loading
        case endLoading
    }
    
    weak var coordinator: FilterCoordinatorProtocol?
    var type: FilterType
    private var dataSource: [FiltersData] = []
    var topText: String
    
    let networkService = NetworkService()
    
    init(topText: String, type: FilterType) {
        self.topText = topText
        self.type = type
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var eventPubisher: AnyPublisher<Event, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func eventOccured(event: Event) {
        eventSubject.send(event)
    }
    
    func setDataSource() {
        switch type {
        case .category:
            for i in Model.categoriesDataSource {
                dataSource.append(FiltersData(id: nil, name: i.0, category: nil, country: nil))
            }
        case .country:
            for i in Model.countriesTwoLettersDataSource {
                dataSource.append(FiltersData(id: nil, name: i.1, category: nil, country: i.0))
            }
        case .source:
            sourcesRequest()
        }
    }
    
    func numberOf() -> Int {
        dataSource.count
    }
    
    func itemAt(at index: Int) -> FiltersData {
        dataSource[index]
    }

    func didSelectAt(at index: Int) {
        for (i, value) in dataSource.enumerated() {
            dataSource[i].chosen = i == index ? !value.chosen : false
        }
    }
    
// MARK: Determine what filter was chosen
    
    func filterBy() -> String? {
        switch type {
        case .category:
            return dataSource.first(where: {$0.chosen == true})?.name
        case .country:
            guard let index = dataSource.firstIndex(where: {$0.chosen == true}) else { return nil}
            return Model.countriesTwoLettersDataSource[index].0
        case .source:
            return dataSource.first(where: {$0.chosen == true})?.id
        }
    }
    
    func backVC() {
        coordinator?.backVC(filterBy: filterBy())
    }
}

// MARK: Sources request

extension FilterViewModel {
    func sourcesRequest() {
        let endpoint = URLExtension.sources.rawValue
        eventOccured(event: .loading)
        
        networkService.sourcesRequest(endpoint: endpoint) { [weak self] status in
            switch status {
            case .success:
                self?.dataSource = self!.networkService.sourcesData
                self?.eventOccured(event: .endLoading)
            case .failure(let error):
                self?.eventOccured(event: .error(errorDescr: error.localizedDescription))
            default:
                break
            }
        }
    }
}
