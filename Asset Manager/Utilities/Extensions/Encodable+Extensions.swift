//
//  Encodable+Extensions.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

extension Encodable {
    
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return [:] }
        return json
    }
}
