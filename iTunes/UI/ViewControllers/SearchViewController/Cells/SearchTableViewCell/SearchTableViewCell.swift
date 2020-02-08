//
//  SearchTableViewCell.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier: String = "searchTableViewCell"
    static let nibName   : String = "SearchTableViewCell"
    
    @IBOutlet weak var titleLable   : UILabel!
    @IBOutlet weak var authorLabel  : UILabel!
    @IBOutlet weak var dateLabel    : UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookImageView.layer.cornerRadius = 10
        bookImageView.layer.borderWidth  = 2
        bookImageView.layer.borderColor  = UIColor.systemPurple.cgColor
    }
    
    func configureCell(book: Book) {
        bookImageView.hero.id = book.id! 
        
        titleLable .text = book.name
        authorLabel.text = book.artistName
        dateLabel  .text = book.releaseDate?.convertDateToUIFormat(apiFormat: .apiFormat, to: .uiFormat)
        
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
    
}
