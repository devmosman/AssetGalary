//
//  LoginModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let user: User
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

// MARK: - User
struct User: Codable {
    let role: String
}
