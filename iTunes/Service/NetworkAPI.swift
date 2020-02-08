//
//  NetworkAPI.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation
import Alamofire

class NetworkAPI {
    func sendRequest<ResponseType>(request: APIRequest<ResponseType>, completion: @escaping (APIResponse<ResponseType>?, Error?) -> Void) {
        guard let urlRequest = urlRequestWith(request: request) else { return }

        AF.request(urlRequest).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let apiResponse = self.successResponse(request: request, data: data)
                completion(apiResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func urlRequestWith<ResponseType>(request: APIRequest<ResponseType>) -> URLRequest? {
        let completeURL: String = request.baseURL  +
                                  request.apiPath  +
                                  request.version  +
                                  request.region   +
                                  request.category +
                                  request.feedType +
                                  request.genre    +
                                  request.count    +
                                  request.jsonType
        print(completeURL)
        guard let url: URL = URL(string: completeURL) else { return nil }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.method = request.requestType
        urlRequest.setValue(request.contentType, forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    func successResponse<ResponseType>(request: APIRequest<ResponseType>, data: Data) -> APIResponse<ResponseType> {
        do {
            let response = try JSONDecoder().decode(ResponseType.self, from: data)
            return APIResponse(data: response, success: true, message: "Başarılı")
        } catch let error {
            return APIResponse(data: nil, success: false, message: error.localizedDescription)
        }
    }
}
