//
//  UIAlertExtension.swift
//

import UIKit

extension UIAlertController {
    static func informativeAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        return alertController
    }
    
    static func deletableAlert(title: String, completion: @escaping (Bool) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: "Are you sure to remove this article from favorite?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }
}
