//
//  SearchViewModel.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import Foundation

class SearchViewModel {
    var feedResponse : FeedResponse!
    var firstResponse: FeedResponse!
    var filteredBooks: [Book] = []
    
    func getData(completation: @escaping (Error?) -> ()) {
        let searchRequest = SearchRequest()
        NetworkAPI().sendRequest(request: searchRequest) { [weak self] (response, error) in
            guard let self = self else { return }
            if let error = error {
                completation(NSError(domain: error.localizedDescription, code: 200, userInfo: nil))
            } else {
                self.feedResponse  = response?.data
                self.firstResponse = response?.data
                self.setForFavorites()
                completation(nil)
            }
        }
    }
    
    func filterResultBySearchType(searchType: SearchViewController.SearchType, kind: Kind?, completation: @escaping () -> ()) {
        switch searchType {
        case .name:
            feedResponse.feed.results = firstResponse.feed.results
            completation()
        case .kind:
            feedResponse.feed.results = feedResponse.feed.results.filter { $0.kind == kind }
            completation()
        }
    }
    
    func filterResultByText(searchText: String, kind: Kind?, completation: @escaping () -> ()) {
        filteredBooks = feedResponse.feed.results.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
        completation()
    }
    
    func setForFavorites(completation: (() -> ())? = nil) {
        if let favorites = UserDefaults.standard.favorites {
            self.feedResponse.feed.results.enumerated().forEach {
                if favorites.contains($0.element.id!) {
                    self.feedResponse.feed.results[$0.offset].isFavorite = true
                } else {
                    self.feedResponse.feed.results[$0.offset].isFavorite = false
                }
            }
        }
    }
}
