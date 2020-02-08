//
//  String+Extensions.swift
//  iTunes
//
//  Created by Developer on 8.02.2020.
//

import Foundation

extension String {
    
    enum DateFormat: String {
        case apiFormat = "yyyy-MM-dd"
        case uiFormat  = "dd.MM.yyyy"
    }
    
    func convertDateToUIFormat(apiFormat: String.DateFormat,to uiFormat: String.DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat.rawValue
        if let apiFormatDate = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = uiFormat.rawValue
            return dateFormatter.string(from: apiFormatDate)
        } else {
            return "-"
        }
    }
}
