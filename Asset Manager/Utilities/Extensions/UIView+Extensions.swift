//
//  UIView+Extensions.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import Foundation
import UIKit

extension UIView {
    
    func makeShadowsAndCorners(cornerRadius: CGFloat = 0, shadowOpacity: Float = 0, shadowOffset: CGSize = .zero, shadowRadius: CGFloat = 0, shadowColor: UIColor = .black) {
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
    }
    
    func makeBorders(borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func uniqueCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
}
