//
//  ChooseFilterCell.swift
// 

import UIKit

class ChooseFilterCell: UITableViewCell {
    private var titleLabel = UILabel(frame: .zero)
    private var valueLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ChooseFilterCell {
    private func setupUI() {
        titleLabel.setStyle(text: nil, textColor: .black, font: UIFont.boldSystemFont(ofSize: 18))
        valueLabel.setStyle(text: nil, textColor: .lightGray, font: UIFont.systemFont(ofSize: 15))
        valueLabel.textAlignment = .right
    }
}

extension ChooseFilterCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20)
        ])
    }
}

extension ChooseFilterCell {
    func configure(titleText: String, valueText: String?) {
        titleLabel.text = titleText
        guard let valueText = valueText else {
            valueLabel.text = ""
            return
        }
        titleLabel.text = titleText
        valueLabel.text = valueText
    }
}
