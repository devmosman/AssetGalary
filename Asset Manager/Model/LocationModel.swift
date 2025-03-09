//
//  LocationModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - LocationModel
struct LocationModel: Codable {
    let data: [LocationModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - LocationModelData
struct LocationModelData: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
}
