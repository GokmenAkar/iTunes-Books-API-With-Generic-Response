//
//  FeedCollectionViewCell.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit
import SDWebImage
import Hero

protocol FeedCellFavoritesDelegate {
    func addBookToFavorites(book: Book)
    func removeBookFromFavorites(book: Book)
}

class FeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "feedCollectionViewCell"
    static let nibName   : String = "FeedCollectionViewCell"
    
    @IBOutlet weak var favoriteButton         : UIButton!
    @IBOutlet weak var bookImageView          : UIImageView!
    @IBOutlet weak var bookTitleLabel         : UILabel!
    @IBOutlet weak var bookTitleBackgroundView: UIView!
    @IBOutlet weak var activityIndicator      : UIActivityIndicatorView!
    
    var isImageSetted: Bool = false
    var book: Book!
    
    var delegate: FeedCellFavoritesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius  = 10
        layer.shadowColor   = UIColor.darkGray.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowRadius  = 4
        layer.shadowOpacity = 0.5
        
        clipsToBounds = false
        
        bookTitleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bookTitleBackgroundView.layer.cornerRadius = 10
        
        bookImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        bookImageView.layer.cornerRadius = 10
    }
    
    func configureCell(book: Book) {
        self.book = book
        bookImageView.hero.id  = book.id!
        
        bookTitleLabel.text = book.name
        let starImage: UIImage = book.isFavorite ? UIImage(systemName: "star.fill")! : UIImage(systemName: "star")!
        favoriteButton.setImage(starImage, for: .normal)
        getImage(with: book.artworkUrl100)
    }
    
    func getImage(with imageURL: String?) {
        guard let _imageUrl = imageURL else {
            activityIndicator.stopAnimating()
            bookImageView.image = UIImage(systemName: "book.circle")
            return
        }
        
        bookImageView.sd_setImage(with: URL(string: _imageUrl)) { (_, error, cache, _) in
            self.activityIndicator.stopAnimating()
            if error != nil {
                self.bookImageView.image = UIImage(systemName: "book.circle")
            } else {
                self.bookImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    @IBAction func addFavorites(_ sender: UIButton) {
        if book.isFavorite {
            book.isFavorite = false
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            delegate?.removeBookFromFavorites(book: book)
        } else {
            book.isFavorite = true
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            delegate?.addBookToFavorites(book: book)
        }
    }
}
