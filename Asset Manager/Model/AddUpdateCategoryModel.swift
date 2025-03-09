//
//  AddUpdateCategoryModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - AddUpdateCategoryModel
struct AddUpdateCategoryModel: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
}
