//
//  FavoriteCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

protocol FavoriteCoordinatorProtocol: AnyObject {
    func backVC(value: Bool)
    func detailNews(urlString: String)
}

protocol FavoriteCoordinatorDelegate: AnyObject {
    func changesMade(value: Bool)
}

final class FavoriteCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: FavoriteCoordinatorDelegate?
    weak var parent: Coordinator?
    var navigationController: UINavigationController?
    
    func start() {
        let vc = FavoriteViewController()
        vc.viewModel.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Notify mainController that changes was made or not, also webview of article

extension FavoriteCoordinator: FavoriteCoordinatorProtocol {
    func backVC(value: Bool) {
        parent?.childDidFinish(childCoordinator: self)
        delegate?.changesMade(value: value)
    }
    
    func detailNews(urlString: String) {
        let detailNewsCoordinator = DetailNewsCoordinator()
        detailNewsCoordinator.parent = self
        detailNewsCoordinator.navigationController = navigationController
        detailNewsCoordinator.urlString = urlString
        childCoordinators.append(detailNewsCoordinator)
        detailNewsCoordinator.start()
    }
}
