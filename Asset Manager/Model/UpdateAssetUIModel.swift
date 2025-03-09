//
//  UpdateAssetUIModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

// MARK: - UpdateAssetUIModel
struct UpdateAssetUIModel: Codable {
    let id: Int
    let code, serialNumber, discription,galleryDescription, price: String?
    let quantity: Int?
    let model: String
    let width, hight: String?
    let purchaseDate, warrantyStartDate, warrantyEndDate: String?
    let notes: String?
    let status: Int
    let locationId, subLocationId, categoryId, subCategoryId: Int
    let vendorId: Int?
    let locationNameAr, locationNameEn: String?
    let subLocationNameAr, subLocationEn: String?
    let categoryNameAr, categoryNameEn, subCategoryNameAr: String?
    let subCategoryNameEn, vendorNameAr, vendorNameEn: String?
    let priceCurrencyId: Int?
    let wUnitId: Int?
    let hUnitId: Int?

}
