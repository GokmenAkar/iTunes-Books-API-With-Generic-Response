//
//  FeedUICollectionViewLayout.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit

class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var hasSetted: Bool = false
    
    override func prepare() {
        if !hasSetted {
            setup()
            hasSetted = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 20
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let sizeValue = collectionView!.bounds.width/2 - minimumInteritemSpacing
        itemSize = CGSize(width: sizeValue, height: sizeValue * 1.5)
    }
}
