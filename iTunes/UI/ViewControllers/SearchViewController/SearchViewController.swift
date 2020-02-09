//
//  SearchViewController.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import UIKit

class SearchViewController: UIViewController {
    enum SearchType {
        case name
        case kind
    }
    var searchType: SearchType = .name
    var bookType  : Kind       = .ibook
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var isSearchActive: Bool = false
    
    let searchViewModel = SearchViewModel()
    
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchViewController()
        setTableViewCells()
        setNavigationBar()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    private func setTableViewCells() {
        let bookNib   = UINib(nibName: BooksTableViewCell.nibName , bundle: nil)
        let searchNib = UINib(nibName: SearchTableViewCell.nibName, bundle: nil)
        
        searchTableView.register(bookNib  , forCellReuseIdentifier: BooksTableViewCell.identifier)
        searchTableView.register(searchNib, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        searchTableView.tableFooterView = UIView()
    }
    
    private func setSearchViewController() {
        title = "Search Books"
        let search = UISearchController(searchResultsController: nil)
        
        search.searchResultsUpdater = self
        search.searchBar.delegate   = self
        search.searchBar.scopeButtonTitles = ["Name", "Kind"]
        search.searchBar.showsScopeBar = true
        search.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        definesPresentationContext = true
    }
    
    private func setNavigationBar() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = .systemOrange
        activityIndicator.hidesWhenStopped = true
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    fileprivate func getData() {
        searchViewModel.getData { [weak self] (error) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if error != nil {
                    self.showAlert(title: "Hata", message: error!.localizedDescription)
                } else {
                    self.searchTableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = searchText != "" && searchText.count > 2
        
        guard isSearchActive else {
            searchTableView.reloadData()
            return
        }
        
        searchViewModel.filterResultByText(searchText: searchText, kind: nil) { [weak self] in
            guard let self = self else {return}
            self.searchTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchType = selectedScope == 0 ? .name : .kind
        isSearchActive = false
        searchBar.text = "" 
        if searchType == .kind {
            showActionSheet(type: .kind)
        } else {
            searchViewModel.filterResultBySearchType(searchType: .name, kind: nil) { [weak self] in
                guard let self = self else {return}
                self.searchTableView.reloadData()
            }
        }
    }
    
    fileprivate func showActionSheet(type: SearchType) {
        let iBookAction: UIAlertAction = UIAlertAction(title: "iBook", style: .default) { (_) in
            self.searchViewModel.filterResultBySearchType(searchType: .kind, kind: .ibook) {
                self.searchTableView.reloadData()
            }
        }
        let ePubAction: UIAlertAction = UIAlertAction(title: "epubBook", style: .default) { (_) in
            self.searchViewModel.filterResultBySearchType(searchType: .kind, kind: .epubBook) {
                self.searchTableView.reloadData()
            }
        }
                
        showAlertWithButtons(title: "Kind",
                             message: "Please select a kind that you want to search",
                             alertActions: iBookAction, ePubAction)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return searchViewModel.filteredBooks.count
        } else {
            return searchViewModel.feedResponse == nil ? 0 : searchViewModel.feedResponse.feed.results.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchActive {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else { return UITableViewCell() }
            cell.configureCell(book: searchViewModel.filteredBooks[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier) as? BooksTableViewCell else { return UITableViewCell() }
            cell.configureCell(book: searchViewModel.feedResponse.feed.results[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            var image: UIImage!
            var book : Book!
            if let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell {
                image = cell.bookImageView.image
                book  = searchViewModel.filteredBooks[indexPath.row]
            } else if let bookCell = tableView.cellForRow(at: indexPath) as? BooksTableViewCell {
                image = bookCell.bookImageView.image
                book  = searchViewModel.feedResponse.feed.results[indexPath.row]
            }
            detailViewController.image = image
            detailViewController.book  = book
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
