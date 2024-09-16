//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 16.09.2024.
//

import Foundation

extension Date {
    
    func stringToDateAndFormatted(from: String) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormater.date(from: from)
    }
}

