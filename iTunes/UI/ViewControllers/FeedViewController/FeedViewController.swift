//
//  FeedViewController.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var feedViewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewCells()
        setCollectionViewLayout()
        getFeedData()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if feedViewModel.feedResponse != nil {
            feedViewModel.filterCurrentValues { [weak self] in
                guard let self = self else {return}
                self.feedCollectionView.reloadData()
            }
        }
    }
    
    private func setCollectionViewCells() {
        let feedNib = UINib(nibName: FeedCollectionViewCell.nibName, bundle: nil)
        feedCollectionView.register(feedNib, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
    }
    
    private func setCollectionViewLayout() {
        feedCollectionView.collectionViewLayout = FeedCollectionViewFlowLayout()
    }
    
    private func setNavigationBar() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = .systemOrange
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    private func setFilterButton() {
        activityIndicator.stopAnimating()
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(filterList))
        filterButton.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func filterList() {
        let allAction = UIAlertAction(title: "All", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.getFilteredData(filterType: .all)
        }
        let newestAction = UIAlertAction(title: "Newest", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.getFilteredData(filterType: .newest)
        }
        let oldestAction = UIAlertAction(title: "Oldest", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.getFilteredData(filterType: .oldest)
        }
        let favoritesAction = UIAlertAction(title: "Favorites", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.getFilteredData(filterType: .favorites)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        showAlertWithButtons(title: "Filter", message: "You can filter results", alertActions: allAction, newestAction, oldestAction, favoritesAction, cancel)
    }
    
    private func getFilteredData(filterType: FeedViewModel.Filter) {
        self.feedViewModel.filterType = filterType
        self.feedViewModel.filterCurrentValues { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
        }
    }
    
    private func getFeedData() {
        feedViewModel.getFeed { [weak self] (error) in
            guard let self = self else { return }
            self.setFilterButton()
            if let error = error {
                self.showAlert(title: "Hata", message: error.localizedDescription)
            } else {
                self.title = self.feedViewModel.feedResponse.feed.title
                self.feedCollectionView.reloadData()
            }
        }
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if feedViewModel.isFiltered {
            return feedViewModel.filteredBooks.count
        } else {
            return feedViewModel.feedResponse == nil ? 0 : feedViewModel.feedResponse.feed.results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        if feedViewModel.feedResponse.feed.results.count - 1 == indexPath.row {
            getFeedData()
        }
        cell.configureCell(book: feedViewModel.isFiltered ? feedViewModel.filteredBooks[indexPath.row] : feedViewModel.feedResponse.feed.results[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            if let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell {
                detailViewController.image = cell.bookImageView.image
                detailViewController.book  = feedViewModel.feedResponse.feed.results[indexPath.row]
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

