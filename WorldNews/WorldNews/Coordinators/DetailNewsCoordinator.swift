//
//  DetailNewsCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

protocol DetailNewsCoordinatorProtocol: AnyObject {
    func backVC()
}

final class DetailNewsCoordinator: Coordinator {
    weak var parent: Coordinator?
    var urlString: String?
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?
    
    func start() {
        let vc = DetailNewsController(urlString: urlString!)
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailNewsCoordinator: DetailNewsCoordinatorProtocol {
    func backVC() {
        parent?.childDidFinish(childCoordinator: self)
    }
}
