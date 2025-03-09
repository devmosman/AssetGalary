//
//  Dictionary+Extension.swift
//  Asset Manager
//
//  Created by Marwan on 30/07/2022.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
