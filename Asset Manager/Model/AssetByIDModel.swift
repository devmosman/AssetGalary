//
//  AssetByIDModel.swift
//  Asset Manager
//
//  Created by Marwan on 22/06/2022.
//

import Foundation

// MARK: - AssetByIDModel
struct AssetByIDModel: Codable {
    let id: Int?
    let code, serialNumber, discription,galleryDescription : String?
    let quantity: Int?
    let price: Double?
    let model, width, hight, purchaseDate: String?
    let warrantyStartDate, warrantyEndDate, notes: String?
    let status, locationID, subLocationID, categoryID: Int?
    let subCategoryID, vendorID: Int?
    let createUserID: Int?
    let createDate: String?
    let lastUpdateUserID: Int?
    let lastUpdateDate, locationCode, locationNameAr, locationNameEn: String?
    let subLocationCode, subLocationNameAr, subLocationEn: String?
    let categoryCode, categoryNameAr, categoryNameEn, subCategoryCode: String?
    let subCategoryNameAr, subCategoryNameEn, vendorNameAr, vendorNameEn: String?
    let vendorAddress: String?
    let vendorNotes: String?
    let currencyDesc: String?
    let priceCurrencyId: String?
    let wUnitId: String?
    let wUnitDesc: String?
    let hUnitId: String?
    let hUnitDesc: String?

    enum CodingKeys: String, CodingKey {
        case id, code, serialNumber, discription,galleryDescription, price, quantity, model, width, hight, purchaseDate, warrantyStartDate, warrantyEndDate, notes, status
        case locationID = "locationId"
        case subLocationID = "subLocationId"
        case categoryID = "categoryId"
        case subCategoryID = "subCategoryId"
        case vendorID = "vendorId"
        case createUserID = "createUserId"
        case createDate
        case lastUpdateUserID = "lastUpdateUserId"
        case lastUpdateDate, locationCode, locationNameAr, locationNameEn, subLocationCode, subLocationNameAr, subLocationEn, categoryCode, categoryNameAr, categoryNameEn, subCategoryCode, subCategoryNameAr, subCategoryNameEn, vendorNameAr, vendorNameEn, vendorAddress, vendorNotes, currencyDesc, priceCurrencyId, wUnitId, wUnitDesc, hUnitId, hUnitDesc
    }
}
