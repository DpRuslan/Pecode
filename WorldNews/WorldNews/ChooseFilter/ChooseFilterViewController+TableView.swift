//
//  ChooseFilterViewController+TableView.swift
//   

import UIKit

extension ChooseFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOf()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseFilterCell", for: indexPath) as! ChooseFilterCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.configure(
            titleText: viewModel.filterAt(at: indexPath.row).0,
            valueText: viewModel.filterAt(at: indexPath.row).1
        )
        
        return cell
    }
}

extension ChooseFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectFilterAt(at: indexPath.row)
    }
}
