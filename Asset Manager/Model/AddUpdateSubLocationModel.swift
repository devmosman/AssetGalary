//
//  AddUpdateSubLocationModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - AddUpdateSubLocationModel
struct AddUpdateSubLocationModel: Codable {
    let id: Int?
    let code, nameAr, nameEn: String?
    let locationID: Int?

    enum CodingKeys: String, CodingKey {
        case id, code, nameAr, nameEn
        case locationID = "locationId"
    }
}
