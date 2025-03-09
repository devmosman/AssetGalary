//
//  DashboardModel.swift
//  Asset Manager
//
//  Created by Marwan on 30/07/2022.
//

import Foundation

// MARK: - DashboardModel
struct DashboardModel: Codable {
    let categoryCount, locationCount, assetCount: Int?
    let assetPriceByCurrency, assetCountByCategory, assetCountByLocation: [AssetDashboard]?
}

// MARK: - AssetDashboard
struct AssetDashboard: Codable {
    let total: Int?
    let code, nameAr, nameEn: String?
    let totalPrice: Double?
}
