//
//  AddUpdateSubCategoryModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - AddUpdateSubCategoryModel
struct AddUpdateSubCategoryModel: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
    let categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id, code, nameAr, nameEn
        case categoryID = "categoryId"
    }
}
