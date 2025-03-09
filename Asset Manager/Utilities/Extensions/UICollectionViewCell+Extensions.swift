//
//  UICollectionViewCell+Extensions.swift
//
//  Created by Marwan on 14/06/2022.
//

import UIKit

extension UICollectionViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
