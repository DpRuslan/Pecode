//
//  UILabelExtension.swift
//

import UIKit

extension UILabel {
    func setStyle(text: String?, textColor: UIColor, font: UIFont) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
