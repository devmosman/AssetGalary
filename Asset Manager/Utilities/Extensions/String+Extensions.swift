//
//  String+Extensions.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import UIKit

extension String {
    
    func imageFromBase64String() -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage ?? UIImage(named: "placeholder")!
    }
    
    func getDateFromString() -> Date? {
        
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = .init(identifier: "Africa/Cairo")
        dateFormatter.locale = .init(identifier: "en_US")
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'h:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = dateFormatter.date(from: self) {
            return dateFormatter.date(from: dateFormatter.string(from: date))//date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "dd/mm/yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
}
