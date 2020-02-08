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
        let image: UIImage = (book.isFavorite ? UIImage(systemName: "star.fill")! : UIImage(systemName: "star"))!
        navigationButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFavorite))
        navigationItem.rightBarButtonItem = navigationButton
    }
    
    @objc func addFavorite() {
        if var favorites = UserDefaults.standard.favorites {
            if favorites.contains(book.id!) {
                if let removeIndex = favorites.firstIndex(of: book.id!) {
                    favorites.remove(at: removeIndex)
                    UserDefaults.standard.favorites = favorites
                    navigationButton.image = UIImage(systemName: "star")
                }
            } else {
                favorites.append(book.id!)
                addFavoritesForFeedResults(book: book)
                UserDefaults.standard.favorites = favorites
                navigationButton.image = UIImage(systemName: "star.fill")
            }
        } else {
            UserDefaults.standard.favorites = [book.id!]
            addFavoritesForFeedResults(book: book)
            navigationButton.image = UIImage(systemName: "star.fill")
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
    
    
    //  We're are filtering favorites book on locale,
    //  and if there is no current favorite book in the feed list we can't see in among favorites,
    //  that's why we are manually adding the book here.
    //  Ex: We fecthed 20 books first, but our new favorite is in 140th book.
    fileprivate func addFavoritesForFeedResults(book: Book) {
        if let navigationController = tabBarController?.viewControllers?.first as? UINavigationController {
            if let feedViewController = navigationController.viewControllers.first as? FeedViewController {
                var favoriteBook = book
                favoriteBook.isFavorite = true
                if !feedViewController.feedViewModel.filteredBooks.contains(favoriteBook) {
                    feedViewController.feedViewModel.filteredBooks.append(favoriteBook)
                }
            }
        }
    }
}
