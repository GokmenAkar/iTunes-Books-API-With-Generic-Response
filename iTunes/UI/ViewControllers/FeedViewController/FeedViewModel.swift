//
//  FeedViewModel.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation

class FeedViewModel {
    enum Filter {
        case all
        case newest
        case oldest
        case favorites
    }
    
    let feedRequest = FeedRequest()
    
    var feedResponse : FeedResponse!
    var firstResponse: FeedResponse!

    var filterType: Filter = .all

    var isFiltered: Bool = false
    var isLoading : Bool = false
    
    var filteredBooks: [Book] = []

    func getFeed(completation: @escaping (Error?) -> ()) {
        guard !isLoading, !isFiltered else { return }
        isLoading = true
        feedRequest.pagination += 20
        if feedRequest.pagination >= 200 { //200'den sonra 404 hatası veriyor
            completation(NSError(domain: "Gösterilebilecek yeni değer yok", code: 200, userInfo: nil))
            isLoading = false
            return
        }
        NetworkAPI().sendRequest(request: feedRequest) { [weak self] (response, error) in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                completation(error)
            } else {
                self.feedResponse  = response?.data
                self.setForFavorites()
                self.firstResponse = self.feedResponse
                
                completation(nil)
            }
        }
    }
    
    func filterCurrentValues(compleation: @escaping () -> ()) {
        switch filterType {
        case .all:
            feedResponse = firstResponse
            setForFavorites(completation: nil)
            isFiltered = false
        case .newest:
            feedResponse = firstResponse
            setForFavorites(completation: nil)
            isFiltered = false
            feedResponse.feed.results.sort { $0.releaseDate! < $1.releaseDate! }
        case .oldest:
            feedResponse = firstResponse
            setForFavorites(completation: nil)
            isFiltered = false
            feedResponse.feed.results.sort { $0.releaseDate! > $1.releaseDate! }
        case .favorites:
            isFiltered = true
            setForFavorites(completation: nil)
            feedResponse.feed.results = feedResponse.feed.results.filter { $0.isFavorite }
        }
        compleation()
    }
    
    func setForFavorites(completation: (() -> ())? = nil) {
        if let favorites = UserDefaults.standard.favorites {
            self.feedResponse.feed.results.enumerated().forEach {
                self.feedResponse.feed.results[$0.offset].isFavorite = true
                if favorites.contains($0.element.id!) && !feedResponse.feed.results.contains(self.feedResponse.feed.results[$0.offset]) {
                    self.filteredBooks.append(self.feedResponse.feed.results[$0.offset])
                } else {
                    self.feedResponse.feed.results[$0.offset].isFavorite = false
                }
            }
        }
    }
}
