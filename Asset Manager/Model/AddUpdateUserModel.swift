//
//  AddUpdateUserModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

// MARK: - AddUpdateUserModel
struct AddUpdateUserModel: Codable {
    let id: Int?
    let userName: String?
    let password: String?
    let email, mobile, fullName, shortName: String?
    let status: Int?
    let userRole: String?
}
