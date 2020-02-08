//
//  Feed.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation

// MARK: - FeedResponse
struct FeedResponse: Codable {
    var feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]?
    let copyright, country: String?
    let icon: String?
    let updated: String?
    var results: [Book]
}

// MARK: - Author
struct Author: Codable {
    let name: String?
    let uri: String?
}

// MARK: - Link
struct Link: Codable {
    let linkSelf: String?
    let alternate: String?

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
        case alternate
    }
}

// MARK: - Result
struct Book: Codable {
    let artistName, id, releaseDate, name: String?
    let kind: Kind?
    let artistID: String?
    let artistURL: String?
    let artworkUrl100: String?
    let genres: [Genre]?
    let url: String?
    var isFavorite: Bool = false 

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name, kind
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url
    }
}

// MARK: - Genre
struct Genre: Codable {
    let genreID, name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Kind: String, Codable {
    case epubBook = "epubBook"
    case ibook = "ibook"
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id! == rhs.id!
    }
}
