//
//  UICollectionView+Extensions.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit

extension UICollectionViewCell {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateSize(isCellSelected: true)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateSize(isCellSelected: false)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateSize(isCellSelected: false)
    }

    func animateSize(isCellSelected: Bool) {
        if isCellSelected {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            self.transform = .identity
            }, completion: nil)
        }
    }
}
