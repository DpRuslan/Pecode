//
//  FavoriteViewController+TableView.swift
//  

import UIKit

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOf()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        cell.delegate = self
        cell.favoriteController = true
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.configure(article: ArticlesData(favoriteArticle: viewModel.articleAt(at: indexPath.row)))

        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectArticleAt(at: indexPath.row)
    }
}

// MARK: Show alert if user wants to delete an article from favorite

extension FavoriteViewController: ArticleCellDelegate {
    func showAlert(completion: @escaping (() -> Void)) {
        present(UIAlertController.deletableAlert(title: "Caution", completion: { flag in
            if flag == true {
                completion()
            }
        }), animated: true)
    }
}
