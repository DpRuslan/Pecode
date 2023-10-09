//
//  FilterCell.swift
//

import UIKit

class FilterCell: UITableViewCell {
    private var titleLabel = UILabel(frame: .zero)
    private var checkMarkImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(titleLabel)
        addSubview(checkMarkImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension FilterCell {
    private func setupUI() {
        titleLabel.setStyle(text: nil, textColor: .black, font: UIFont.boldSystemFont(ofSize: 17))
        
        checkMarkImageView.contentMode = .scaleToFill
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FilterCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            checkMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension FilterCell {
    func configure(titleText: String, checkmark: Bool) {
        titleLabel.text = titleText
        if checkmark {
            checkMarkImageView.image = Model.checkmarkImage
        } else {
            checkMarkImageView.image = nil
        }
    }
}
