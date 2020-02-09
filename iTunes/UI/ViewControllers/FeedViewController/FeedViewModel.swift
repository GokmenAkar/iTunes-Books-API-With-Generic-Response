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
    
    var favoriteBooks: [Book] = []
    
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
            setForFavorites(nil)
            isFiltered = false
        case .newest:
            feedResponse = firstResponse
            setForFavorites(nil)
            isFiltered = false
            feedResponse.feed.results.sort { $0.releaseDate! < $1.releaseDate! }
        case .oldest:
            feedResponse = firstResponse
            setForFavorites(nil)
            isFiltered = false
            feedResponse.feed.results.sort { $0.releaseDate! > $1.releaseDate! }
        case .favorites:
            isFiltered = true
            setFavorites()
        }
        compleation()
    }
    
    func setForFavorites(_ completation: (() -> ())? = nil) {
        feedResponse.feed.results.enumerated().forEach {
            if favoriteBooks.contains($0.element) {
                feedResponse.feed.results[$0.offset].isFavorite = true
            } else {
                feedResponse.feed.results[$0.offset].isFavorite = false
            }
        }
    }
    
    func setFavorites() {
        if let favoritesData = UserDefaults.standard.favoritesData {
            favoriteBooks = convertDataToStruct(data: favoritesData)
            favoriteBooks.enumerated().forEach {
                favoriteBooks[$0.offset].isFavorite = true
            }
        }
    }
    
    func addFavorites(book: Book) {
        favoriteBooks.append(book)
        UserDefaults.standard.favoritesData = convertStructToData(value: favoriteBooks)
    }
    
    func removeFromFavorites(book: Book) {
        if let index = favoriteBooks.firstIndex(of: book) {
            favoriteBooks.remove(at: index)
            UserDefaults.standard.favoritesData = convertStructToData(value: favoriteBooks)
        }
    }
}
