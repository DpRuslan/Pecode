//
//  LoadingCell.swift
//

import UIKit

class LoadingCell: UITableViewCell {
    private let activityIndicatorView = UIActivityIndicatorView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(activityIndicatorView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingCell {
    private func setupUI() {
        activityIndicatorView.color = .black
        activityIndicatorView.style = .medium
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension LoadingCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension LoadingCell {
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
}
