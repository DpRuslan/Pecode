//
//  FavoriteViewController.swift
//

import UIKit
import Combine

class FavoriteViewController: UIViewController {
    var viewModel: FavoriteViewModel
    
    private var topLabel = UILabel(frame: .zero)
    private var backButton = UIButton(frame: .zero)
    private var tableView = UITableView(frame: .zero, style: .plain)
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        viewModel = FavoriteViewModel()
        
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
        
        setupConstraints()
    }
}

extension FavoriteViewController {
    private func setupBinder() {
        viewModel.eventPubisher.sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

extension FavoriteViewController {
    private func setupUI() {
        topLabel.setStyle(text: viewModel.favoriteNews, textColor: .black, font: UIFont.boldSystemFont(ofSize: 28))
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FavoriteViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoriteViewController {
    @objc private func backPressed(_ sender: Any) {
        viewModel.backVC()
    }
}
