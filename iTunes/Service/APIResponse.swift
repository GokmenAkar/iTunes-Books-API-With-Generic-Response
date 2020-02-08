//
//  APIResponse.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation

struct APIResponse<ResponseType> {
    let data: ResponseType?
    let success: Bool
    let message: String
}
