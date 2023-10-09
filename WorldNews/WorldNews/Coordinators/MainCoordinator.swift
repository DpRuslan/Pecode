//
//  MainCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

protocol MainCoordinatorProtocol: AnyObject {
    func filterVC()
    func favoriteVC()
    func detailNews(urlString: String)
}

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parent: Coordinator?
    var navigationController: UINavigationController?
    let vc = MainViewController()
    
    func start() {
        vc.viewModel.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Pressed filter icon, favorite icon and ArticleCell

extension MainCoordinator: MainCoordinatorProtocol {
    func filterVC() {
        let chooseFilterCoordinator = ChooseFilterCoordinator()
        chooseFilterCoordinator.parent = self
        chooseFilterCoordinator.delegate = self
        chooseFilterCoordinator.navigationController = navigationController
        childCoordinators.append(chooseFilterCoordinator)
        chooseFilterCoordinator.start()
    }
    
    func favoriteVC() {
        let favoriteCoordinator = FavoriteCoordinator()
        favoriteCoordinator.parent = self
        favoriteCoordinator.delegate = self
        favoriteCoordinator.navigationController = navigationController
        childCoordinators.append(favoriteCoordinator)
        favoriteCoordinator.start()
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

//MARK: Handle when filter is chosen

extension MainCoordinator: ChooseFilterCoordinatorDelegate {
    func filterRequest(withText: String?, endpoint: String?) {
        guard let text = withText,
              let endpoint = endpoint else { return }
        vc.viewModel.resetAll()
        vc.viewModel.articlesRequest(q: text, endpoint: endpoint)
    }
}

//MARK: Handle if in FavoriteViewController uncheck favorite icon

extension MainCoordinator: FavoriteCoordinatorDelegate {
    func changesMade(value: Bool) {
        if value {
            vc.viewModel.resetAll()
            vc.viewModel.articlesRequest(q: vc.viewModel.q, endpoint: vc.viewModel.endpoint)
        }
    }
}

