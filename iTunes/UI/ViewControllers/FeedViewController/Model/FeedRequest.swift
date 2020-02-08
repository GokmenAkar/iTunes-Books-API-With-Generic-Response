//
//  FeedRequest.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation
import Alamofire

class FeedRequest: APIRequest<FeedResponse> {
    var pagination: Int = 0
    
    override var count: String {
        get {
            return "\(pagination)/"
        }
    }
    
    override var category: String {
        return "books/"
    }
    
    override var requestType: HTTPMethod {
        return .get
    }
}
