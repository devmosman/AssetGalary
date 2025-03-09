//
//  PhotoDetailsSmallCVCell.swift
//  Asset Manager
//
//  Created by Marwan on 31/07/2022.
//

import UIKit

class PhotoDetailsSmallCVCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var assetImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowRadius = 4
        bgView.layer.shadowOpacity = 0.15
        bgView.layer.shadowOffset = .zero
        bgView.layer.cornerRadius = 5
        assetImageView.layer.cornerRadius = 5
    }

}
