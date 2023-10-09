//
//  FilterViewController.swift
//

import UIKit
import Combine

final class FilterViewController: UIViewController {
    var viewModel: FilterViewModel
    
    private var topLabel = UILabel(frame: .zero)
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var backButton = UIButton(frame: .zero)
    private var loadingView = UIView(frame: .zero)
    private var activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(type: FilterType) {
        self.viewModel = FilterViewModel(topText: type.topText, type: type)
        
        super.init(nibName: nil, bundle: nil)
        
        setupBinder()
        viewModel.setDataSource()
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

extension FilterViewController {
    private func setupBinder() {
        viewModel.eventPubisher.sink { [weak self] event in
            switch event {
            case .loading:
                self?.view.addSubview(self!.loadingView)
                self?.loadingView.addSubview(self!.activityIndicator)
                self?.backButton.isEnabled = false
                self?.activityIndicator.startAnimating()
            case .endLoading:
                DispatchQueue.main.async {
                    self?.loadingView.removeFromSuperview()
                    self?.backButton.isEnabled = true
                    self?.tableView.reloadData()
                }
            case .error(let errorDescr):
                DispatchQueue.main.async {
                    self?.present(UIAlertController.informativeAlert(title: "Error", message: errorDescr), animated: true)
                    self?.loadingView.removeFromSuperview()
                    self?.backButton.isEnabled = true
                }
            }
        }.store(in: &cancellables)
    }
}

extension FilterViewController {
    private func setupUI() {
        topLabel.setStyle(text: viewModel.topText, textColor: .black, font: UIFont.boldSystemFont(ofSize: 28))
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.frame = view.frame
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
    }
}

extension FilterViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FilterViewController {
    @objc private func backPressed(_ sender: Any) {
        viewModel.backVC()
    }
}
