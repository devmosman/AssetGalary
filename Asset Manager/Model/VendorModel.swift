//
//  VendorModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - VendorModel
struct VendorModel: Codable {
    let data: [VendorModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - VendorModelData
struct VendorModelData: Codable {
    let id: Int?
    let nameAr, nameEn: String?
    let address, notes: String?
}
