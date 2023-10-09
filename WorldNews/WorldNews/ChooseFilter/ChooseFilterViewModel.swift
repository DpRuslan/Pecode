//
//  ChooseFilterViewModel.swift
//  

import Foundation
import Combine

final class ChooseFiterViewModel {
    weak var coordinator: ChooseFilterCoordinatorProtocol?
    private var dataSource = Model.filtersDataSource
    let filters = Model.filters
    let clearFilter = Model.clearFilter
    
    var selectedIndex: Int?
    var filterType: FilterType?
    var hasFilter = false
    
    private let eventSubject = PassthroughSubject<Void, Never>()
    
    var eventPubisher: AnyPublisher<Void, Never> {
        return eventSubject.eraseToAnyPublisher()
    }
    
    func eventOccured() {
        eventSubject.send()
    }
    
    func numberOf() -> Int {
        dataSource.count
    }
    
    func filterAt(at index: Int) -> (String, String?) {
        (dataSource[index].0, dataSource[index].1)
    }
    
    func didSelectFilterAt(at index: Int) {
        guard let filterType = FilterType(rawValue: index) else { return }
        selectedIndex = index
        self.filterType = filterType
        coordinator?.filterVC(filterType: filterType)
    }
    
    func updateDataSource(text: String?) {
        guard let text = text else {
            return
        }
        clearAllFilters()
        dataSource[selectedIndex!].1 = text
        hasFilter = true
        eventOccured()
    }
    
    func clearAllFilters() {
        for i in 0 ..< dataSource.count {
            dataSource[i].1 = nil
        }
    }
    
    func backVC() {
        var text: String? = nil
        for element in dataSource {
            if let secondElement = element.1 {
                text = secondElement
            }
        }
        coordinator?.backVC(filterBy: text, endpoint: filterType?.endPoint)
    }
}
