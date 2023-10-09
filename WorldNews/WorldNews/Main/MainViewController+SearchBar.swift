//
//  MainViewController+SearchBar.swift
//

import UIKit

// MARK: Search news by word

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.searchTextField.text {
            searchBar.text = ""
            viewModel.q = text.replacingOccurrences(of: " ", with: "")
            viewModel.resetAll()
            viewModel.articlesRequest(q: viewModel.q, endpoint: viewModel.endpoint)
        }
        searchBar.resignFirstResponder()
    }
}
