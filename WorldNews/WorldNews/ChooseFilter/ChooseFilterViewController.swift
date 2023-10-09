//
//  ChooseFilterViewController.swift
//

import UIKit
import Combine

final class ChooseFilterViewController: UIViewController {
    var viewModel: ChooseFiterViewModel
    
    private var topLabel = UILabel(frame: .zero)
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var backButton = UIButton(frame: .zero)
    var noFilterButton = UIButton(frame: .zero)
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.viewModel = ChooseFiterViewModel()
        
        super.init(nibName: nil, bundle: nil)
        
        setupBinder()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.titleView = topLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.addSubview(tableView)
        view.addSubview(noFilterButton)
        
        setupConstraints()
    }
}

extension ChooseFilterViewController {
    private func setupBinder() {
        viewModel.eventPubisher.sink { [weak self] in
            self?.tableView.reloadData()
            if self!.viewModel.hasFilter {
                self?.noFilterButton.isHidden = false
            } else {
                self?.noFilterButton.isHidden = true
            }
        }.store(in: &cancellables)
    }
}

extension ChooseFilterViewController {
    private func setupUI() {
        topLabel.setStyle(text: viewModel.filters, textColor: .black, font: UIFont.boldSystemFont(ofSize: 28))
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        tableView.register(ChooseFilterCell.self, forCellReuseIdentifier: "ChooseFilterCell")
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        noFilterButton.setTitle(viewModel.clearFilter, for: .normal)
        noFilterButton.addTarget(self, action: #selector(clearFilterPressed(_:)), for: .touchUpInside)
        noFilterButton.setTitleColor(.white, for: .normal)
        noFilterButton.backgroundColor = .black
        noFilterButton.layer.cornerRadius = 10
        noFilterButton.isHidden = true
        noFilterButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ChooseFilterViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            noFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noFilterButton.heightAnchor.constraint(equalToConstant: 60),
            noFilterButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25)
        ])
    }
}

extension ChooseFilterViewController {
    @objc private func backPressed(_ sender: Any) {
        viewModel.backVC()
    }
    
    @objc private func clearFilterPressed(_ sender: Any) {
        viewModel.clearAllFilters()
        tableView.reloadData()
        noFilterButton.isHidden = true
    }
}
