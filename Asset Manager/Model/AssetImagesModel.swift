//
//  AssetImagesModel.swift
//  Asset Manager
//
//  Created by Marwan on 22/06/2022.
//

import Foundation

// MARK: - ImageModel
struct ImageModel: Codable {
    let id, assetID: Int
    let fileName, orignalFileName, filePath, fileData: String

    enum CodingKeys: String, CodingKey {
        case id
        case assetID = "assetId"
        case fileName, orignalFileName, filePath, fileData
    }
}

typealias AssetImagesModel = [ImageModel]
