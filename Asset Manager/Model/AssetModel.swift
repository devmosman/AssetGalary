//
//  AssetModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

// MARK: - AssetModel
struct AssetModel: Codable {
    let data: [AssetModelData]?
    let page, limit, totalRowCount: Int?
}

// MARK: - AssetModelData
struct AssetModelData: Codable {
    let id: Int?
    let code, serialNumber, discription , galleryDescription: String?
    let price: Double?
    let quantity: Int?
    let model, width, hight: String?
    let purchaseDate, warrantyStartDate, warrantyEndDate: String?
    let notes: String?
    let status: Int?
    let locationID, subLocationID, categoryID, subCategoryID: Int?
    let vendorID, createUserID: Int?
    let createDate: String?
    let lastUpdateUserID: Int?
    let lastUpdateDate, locationCode, locationNameAr: String?
    let locationNameEn, subLocationCode, subLocationNameAr, subLocationEn: String?
    let categoryCode, categoryNameAr, categoryNameEn, subCategoryCode: String?
    let subCategoryNameAr, subCategoryNameEn, vendorNameAr, vendorNameEn: String?
    let vendorAddress, vendorNotes: String?
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
