//
//  DetailViewController.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit
import Hero

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var scrollView   : UIScrollView!
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel  : UILabel!

    var book : Book!
    var image: UIImage!
    
    var navigationButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setContent()
    }
    
    fileprivate func setNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let image: UIImage = checkForFavorite(book: book) ? UIImage(systemName: "star.fill")! : UIImage(systemName: "star")!
        navigationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFavorite))
        navigationItem.rightBarButtonItem = navigationButton
    }
    
    @objc func addFavorite() {
        if checkForFavorite(book: book) {
            navigationButton.image = UIImage(systemName: "star")
            addFavoritesForFeedResults(book: book, isFavorite: false)
        } else {
            navigationButton.image = UIImage(systemName: "star.fill")
            addFavoritesForFeedResults(book: book, isFavorite: true)
        }
    }
    
    fileprivate func setContent() {
        bookImageView.layer.cornerRadius = 10
        bookImageView.layer.borderWidth = 4
        bookImageView.layer.borderColor = UIColor.purple.cgColor
        
        bookImageView.hero.id = book.id!
        bookImageView.image   = image
        
        titleLabel .text = book.name
        authorLabel.text = book.artistName
        dateLabel  .text = book.releaseDate?.convertDateToUIFormat(apiFormat: .apiFormat, to: .uiFormat)
        
        scrollView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    fileprivate func addFavoritesForFeedResults(book: Book, isFavorite: Bool) {
        if let navigationController = tabBarController?.viewControllers?.first as? UINavigationController {
            if let feedViewController = navigationController.viewControllers.first as? FeedViewController {
                if isFavorite {
                    var favoriteBook = book
                    favoriteBook.isFavorite = true
                    feedViewController.feedViewModel.addFavorites(book: book)
                } else {
                    feedViewController.feedViewModel.removeFromFavorites(book: book)
                }
            }
        }
    }
    
    fileprivate func checkForFavorite(book: Book) -> Bool {
        if let navigationController = tabBarController?.viewControllers?.first as? UINavigationController {
            if let feedViewController = navigationController.viewControllers.first as? FeedViewController {
                let isFavorite: Bool = feedViewController.feedViewModel.favoriteBooks.contains(book)
                return isFavorite
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
