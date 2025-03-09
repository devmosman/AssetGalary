//
//  UIImage+Extensions.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import UIKit

extension UIImage {
    func convertImageToBase64EncodedString() -> String {
        let imageData: NSData = self.jpegData(compressionQuality: 0.4)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return  "\(imageStr)"
    }
}
