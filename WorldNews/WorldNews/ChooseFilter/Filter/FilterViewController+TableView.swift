//
//  FilterViewController+TableView.swift
//

import UIKit

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOf()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.configure(
            titleText: viewModel.itemAt(at: indexPath.row).name,
            checkmark: viewModel.itemAt(at: indexPath.row).chosen
        )
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectAt(at: indexPath.row)
        tableView.reloadData()
    }
}
