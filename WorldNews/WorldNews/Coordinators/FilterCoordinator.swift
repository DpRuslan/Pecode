//
//  FilterCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

enum FilterType: Int {
    case category = 0
    case country
    case source
    
    var topText: String {
        switch self {
        case .category:
            return Model.categoriesFilter
        case .country:
            return Model.countriesFilter
        case .source:
            return Model.sourcesFilter
        }
    }
    
    var endPoint: String {
        switch self {
        case .category:
            return URLExtension.filteredByCategory.rawValue
        case .country:
            return URLExtension.filteredByCountry.rawValue
        case .source:
            return URLExtension.filteredBySource.rawValue
        }
    }
}

protocol FilterCoordinatorProtocol: AnyObject {
    func backVC(filterBy: String?)
}

protocol FilterCoordinatorDelegate: AnyObject {
    func updateFilterCell(withText: String?)
}

final class FilterCoordinator: Coordinator {
    weak var delegate: FilterCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var type: FilterType?
    var navigationController: UINavigationController?
    weak var parent: Coordinator?
    
    func start() {
        let vc = FilterViewController(type: type!)
        vc.viewModel.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Notify ChooseFilterCoordinator if filter was chosen

extension FilterCoordinator: FilterCoordinatorProtocol {
    func backVC(filterBy: String?) {
        parent?.childDidFinish(childCoordinator: self)
        delegate?.updateFilterCell(withText: filterBy)
    }
}
