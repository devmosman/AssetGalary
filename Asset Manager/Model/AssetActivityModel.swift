//
//  AssetActivityModel.swift
//  Asset Manager
//
//  Created by Marwan on 29/07/2022.
//

import Foundation

// MARK: - AssetActivityModelElement
struct AssetActivityModelElement: Codable {
    let id, assetID: Int?
    let actionDate, actionDescription, detailInfo: String?
    let userID: Int?
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case assetID = "assetId"
        case actionDate, actionDescription, detailInfo
        case userID = "userId"
        case userName
    }
}

typealias AssetActivityModel = [AssetActivityModelElement]
