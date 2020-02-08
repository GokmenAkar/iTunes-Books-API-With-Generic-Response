//
//  UIViewController+Extensions.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit
extension UIViewController {
    func showAlert(title: String, message: String, attributedMessage: String? = nil, mutableAttributedString: NSMutableAttributedString? = nil, alertAction: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alert = UIAlertAction(title: "Tamam", style: .default, handler: alertAction)
        alertController.addAction(alert)
        alertController.view.tintColor = UIColor.purple
        
        if let attribute = attributedMessage {
            alertController.setValue(mutableAttributedString, forKey: attribute)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithButtons(title: String, message: String, alertActions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertActions.forEach { (alert) in
            alertController.addAction(alert)
        }
        alertController.view.tintColor = UIColor.purple
        present(alertController, animated: true, completion: nil)
    }
}
