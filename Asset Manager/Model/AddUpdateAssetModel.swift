//
//  AddUpdateAssetModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

// MARK: - AddUpdateAssetModel
struct AddUpdateAssetModel: Codable {
    let id: Int?
    let code, serialNumber, price: String?
    let quantity: Int?
    let model, width, hight: String?
    let purchaseDate, warrantyStartDate, warrantyEndDate: String?
    let notes: String?
    let status: Int?
    let locationID, subLocationID, categoryID, subCategoryID: Int?
    let vendorID, createUserID, lastUpdateUserID: Int?
    let lastUpdateDate, createDate: String?
    let discription: String?
    let galleryDescription: String?
    let priceCurrencyId: Int?
    let wUnitId: Int?
    let hUnitId: Int?

    enum CodingKeys: String, CodingKey {
        case id, code, serialNumber, price, quantity, model, width, hight, purchaseDate, warrantyStartDate, warrantyEndDate, notes, status
        case locationID = "locationId"
        case subLocationID = "subLocationId"
        case categoryID = "categoryId"
        case subCategoryID = "subCategoryId"
        case vendorID = "vendorId"
        case createUserID = "createUserId"
        case createDate
        case lastUpdateUserID = "lastUpdateUserId"
        case lastUpdateDate, discription, priceCurrencyId,galleryDescription, wUnitId, hUnitId
    }
}
