//
//  MainViewController.swift
//

import UIKit
import Combine

class MainViewController: UIViewController {
    var viewModel: MainViewModel
    
    private var appNameLabel = UILabel(frame: .zero)
    private var favoriteButton = UIButton(frame: .zero)
    private var filterButton = UIButton(frame: .zero)
    private var searchBar = UISearchBar(frame: .zero)
    private var tableView = UITableView(frame: .zero, style: .plain)
    
    private var loadingView = UIView(frame: .zero)
    private var activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh(_:)),
            for: UIControl.Event.valueChanged
        )
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    init() {
        viewModel = MainViewModel()
        
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
        
        hideKeyboardWhenTappedAround()
        viewModel.articlesRequest(q: viewModel.q, endpoint: viewModel.endpoint)
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        setupConstraints()
    }
}

extension MainViewController {
    private func setupBinder() {
        viewModel.eventPubisher.sink { [weak self] event in
            switch event {
            case .error(let errorDescr):
                DispatchQueue.main.async {
                    self?.present(UIAlertController.informativeAlert(title: "Error", message: errorDescr), animated: true)
                    self?.loadingView.removeFromSuperview()
                    self?.enableNavBarElements()
                    self?.scrollTableViewToLastCell()
                }
            case .update:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .loading:
                self?.view.addSubview(self!.loadingView)
                self?.disableNavBarElements()
                self?.loadingView.addSubview(self!.activityIndicator)
                self?.activityIndicator.startAnimating()
                self?.refreshControl.endRefreshing()
                
            case .endLoading:
                DispatchQueue.main.async {
                    self?.loadingView.removeFromSuperview()
                    self?.scrollTableViewToTheFirstCell()
                    self?.enableNavBarElements()
                }
            }
        }.store(in: &cancellables)
    }
}

extension MainViewController {
    private func setupUI() {
        appNameLabel.setStyle(text: viewModel.appName, textColor: .black, font: UIFont.boldSystemFont(ofSize: 30))
        
        favoriteButton.setImage(viewModel.favoriteImage, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoritePressed(_:)), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        filterButton.setImage(viewModel.filterImage, for: .normal)
        filterButton.addTarget(self, action: #selector(filterPressed(_:)), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = viewModel.searchPlaceholder
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
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

extension MainViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MainViewController {
    @objc private func favoritePressed(_ sender: Any) {
        viewModel.favoriteVC()
    }
    
    @objc private func filterPressed(_ sender: Any) {
        viewModel.filterVC()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.dataSource = []
        viewModel.networkService.articlesData = []
        viewModel.pageNumber = 1
        viewModel.planAllowsMoreData = true
        viewModel.isRefreshing = true
        tableView.reloadData()
        viewModel.articlesRequest(q: viewModel.q, endpoint: viewModel.endpoint)
        refreshControl.endRefreshing()
    }
}

extension MainViewController {
    private func scrollTableViewToLastCell() {
        DispatchQueue.main.async {
            if !self.viewModel.dataSource.isEmpty {
                let indexPath = IndexPath(row: self.viewModel.articlesNumberOf()-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func scrollTableViewToTheFirstCell() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension MainViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}

extension MainViewController {
    private func disableNavBarElements() {
        DispatchQueue.main.async {
            self.searchBar.searchTextField.isEnabled = false
            self.favoriteButton.isEnabled = false
            self.filterButton.isEnabled = false
        }
    }
    
    private func enableNavBarElements() {
        searchBar.searchTextField.isEnabled = true
        favoriteButton.isEnabled = true
        filterButton.isEnabled = true
    }
}

