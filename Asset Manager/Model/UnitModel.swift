//
//  UnitModel.swift
//  Asset Manager
//
//  Created by Marwan on 29/07/2022.
//

import Foundation

// MARK: - UnitModelElement
struct UnitModelElement: Codable {
    let id: Int
    let name: String
    let isDefault: Bool
}

typealias UnitModel = [UnitModelElement]


