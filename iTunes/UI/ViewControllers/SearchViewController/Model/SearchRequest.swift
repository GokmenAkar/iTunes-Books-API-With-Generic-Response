//
//  SearchRequest.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import Foundation

class SearchRequest: APIRequest<FeedResponse> {
    override var count: String {
        return "200/"
    }
    
    override var category: String {
        return "books/"
    }
}
