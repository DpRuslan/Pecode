//
//  ChooseFilterCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

protocol ChooseFilterCoordinatorProtocol: AnyObject {
    func backVC(filterBy: String?, endpoint: String?)
    func filterVC(filterType: FilterType)
}

protocol ChooseFilterCoordinatorDelegate: AnyObject {
    func filterRequest(withText: String?, endpoint: String?)
}

final class ChooseFilterCoordinator: Coordinator {
    weak var delegate: ChooseFilterCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    let vc = ChooseFilterViewController()
    
    var navigationController: UINavigationController?
    weak var parent: Coordinator?
    
    func start() {
        vc.viewModel.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Notify MainCoordinator if filter is still chosen

extension ChooseFilterCoordinator: ChooseFilterCoordinatorProtocol {
    func backVC(filterBy: String?, endpoint: String?) {
        parent?.childDidFinish(childCoordinator: self)
        delegate?.filterRequest(withText: filterBy, endpoint: endpoint)
    }
    
// MARK: Navigate to concrete filterView
    
    func filterVC(filterType: FilterType) {
        let filterCoordinator = FilterCoordinator()
        filterCoordinator.parent = self
        filterCoordinator.navigationController = navigationController
        filterCoordinator.type = filterType
        filterCoordinator.delegate = self
        childCoordinators.append(filterCoordinator)
        filterCoordinator.start()
    }
}

// MARK: Update FilterCell if filter was chosen

extension ChooseFilterCoordinator: FilterCoordinatorDelegate {
    func updateFilterCell(withText: String?) {
        vc.viewModel.updateDataSource(text: withText)
    }
}
