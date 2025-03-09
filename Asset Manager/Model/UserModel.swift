//
//  UserModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let data: [UserModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - UserModelData
struct UserModelData: Codable {
    let id: Int?
    let userName: String?
    let password: String?
    let email, mobile, fullName, shortName: String?
    let status: Int?
    let userRole: String?
}
