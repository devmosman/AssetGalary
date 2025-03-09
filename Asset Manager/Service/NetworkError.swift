//
//  NetworkError.swift
//  WegooDriver
//
//  Created by Marwan on 22/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case server(desc: String, statusCode: Int)
    case noInternet
    case notAuthorized
    case invalidData
    case notFound
    
    var desc: String {
        switch self {
        case .invalidData: return "Invalid Data Response"
        case .noInternet: return "Check your internet conncection"
        case .notAuthorized: return "You are not authoriezed, please login"
        case .server: return "Something went wrong, please try again"
        case .notFound: return "Not Found"
        }
    }
}
