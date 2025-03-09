//
//  CategoriesTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class CategoriesTVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameArLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 10
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowRadius = 4
        bgView.layer.shadowOffset = .init(width: 0, height: 3)
        bgView.layer.shadowOpacity = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(categoryModel: CategoryModelData) {
        idLabel.text = "\(categoryModel.id ?? 0)"
        codeLabel.text = categoryModel.code
        nameArLabel.text = categoryModel.nameAr
        nameEnLabel.text = categoryModel.nameEn
        
    }
    
    func configure(locationModel: LocationModelData) {
        idLabel.text = "\(locationModel.id ?? 0)"
        codeLabel.text = locationModel.code
        nameArLabel.text = locationModel.nameAr
        nameEnLabel.text = locationModel.nameEn
    }
    
    
    
}
