//
//  AddUpdateLocationModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - AddUpdateLocationModel
struct AddUpdateLocationModel: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
}
