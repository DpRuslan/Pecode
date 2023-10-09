//
//  MainViewController+TableView.swift
//  WorldNews
//

import UIKit

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let extraRow = viewModel.isLoadingData ? 1 : 0
        return viewModel.articlesNumberOf() + extraRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.articlesNumberOf() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.startAnimating()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
            
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.configure(article: viewModel.articleAt(at: indexPath.row))
           
            return cell
        }
    }
}

// MARK: If last cell then start downloading new data

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.articlesNumberOf() - 1 && !viewModel.isLoadingData && viewModel.planAllowsMoreData {
            if viewModel.planAllowsMoreData {
                viewModel.isLoadingData = true
                viewModel.pageNumber += 1
                viewModel.articlesRequest(q: viewModel.q, endpoint: viewModel.endpoint)
            }
        }
    }
    
// MARK: Show webView of a specific article
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectArticleAt(at: indexPath.row)
    }
}

// MARK: Show alert if user wants to delete an article from favorite

extension MainViewController: ArticleCellDelegate {
    func showAlert(completion: @escaping (() -> Void)) {
        present(UIAlertController.deletableAlert(title: "Caution", completion: { flag in
            if flag == true {
                completion()
            }
        }), animated: true)
    }
}
