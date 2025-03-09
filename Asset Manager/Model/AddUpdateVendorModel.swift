//
//  AddUpdateVendorModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

// MARK: - AddUpdateVendorModel
struct AddUpdateVendorModel: Codable {
    let id: Int?
    let nameAr, nameEn: String?
    let address, notes: String?
}
