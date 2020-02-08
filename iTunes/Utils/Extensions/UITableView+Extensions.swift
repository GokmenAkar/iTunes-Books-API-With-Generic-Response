//
//  UITableView+Extensions.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import UIKit

extension UICollectionView {
    func setInfo(text: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height))
        messageLabel.text = text
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Helvetica-Neue", size: 17)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
}
