//
//  CategoryModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - CategoryModel
struct CategoryModel: Codable {
    let data: [CategoryModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - CategoryModelData
struct CategoryModelData: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
}
