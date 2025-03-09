//
//  SubCategoryModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - SubCategoryModel
struct SubCategoryModel: Codable {
    let data: [SubCategoryModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - SubCategoryModelData
struct SubCategoryModelData: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
    let categoryID: Int?
    let categoryCode, categoryNameAr: String?
    let categoryNameEn: String?

    enum CodingKeys: String, CodingKey {
        case id, code, nameAr, nameEn
        case categoryID = "categoryId"
        case categoryCode, categoryNameAr, categoryNameEn
    }
}
