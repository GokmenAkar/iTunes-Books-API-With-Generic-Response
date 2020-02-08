//
//  FeedCollectionViewCell.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit
import SDWebImage
import Hero

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
        if var favorites = UserDefaults.standard.favorites {
            print("book id:" ,book.id!)
            if favorites.contains(book.id!) {
                if let removeIndex = favorites.firstIndex(of: book.id!) {
                    favorites.remove(at: removeIndex)
                    UserDefaults.standard.favorites = favorites
                    sender.setImage(UIImage(systemName: "star"), for: .normal)
                }
            } else {
                favorites.append(book.id!)
                UserDefaults.standard.favorites = favorites
                sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        } else {
            UserDefaults.standard.favorites = [book.id!]
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
}
