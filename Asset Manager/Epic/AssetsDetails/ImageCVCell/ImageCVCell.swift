//
//  ImageCVCell.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class ImageCVCell: UICollectionViewCell {
    
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var deleteView: UIView!
    
    var didTapDelete: (() -> ())?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        assetImageView.layer.cornerRadius = 5
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowOpacity = 0.1
        deleteView.uniqueCorners(topLeft: 0, topRight: 5, bottomLeft: 20, bottomRight: 0)
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        didTapDelete?()
    }
    
    
}
