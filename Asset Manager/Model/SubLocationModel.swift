//
//  SubLocationModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - SubLocationModel
struct SubLocationModel: Codable {
    let data: [SubLocationModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - SubLocationModelData
struct SubLocationModelData: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
    let locationID: Int?
    let locationCode: String?
    let locationNameAr: String?
    let locationNameEn: String

    enum CodingKeys: String, CodingKey {
        case id, code, nameAr, nameEn
        case locationID = "locationId"
        case locationCode, locationNameAr, locationNameEn
    }
}
