//
//  SubCategoriesTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class SubCategoriesTVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var categoryLocationIDStaticLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameArLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var categoryOrLocationID: UILabel!
    @IBOutlet weak var categoryOrLocationCode: UILabel!
    @IBOutlet weak var categoryOrLocationNameEN: UILabel!
    @IBOutlet weak var categoryOrLocationNameAR: UILabel!
    @IBOutlet weak var categoryLocationCodeStatic: UILabel!
    @IBOutlet weak var categoryLocationNameENStatic: UILabel!
    @IBOutlet weak var categoryLocationNameARStatic: UILabel!
    
    
    
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
    
    func configure(subCategoryModel: SubCategoryModelData) {
        idLabel.text = "\(subCategoryModel.id ?? 0)"
        codeLabel.text = subCategoryModel.code
        nameArLabel.text = subCategoryModel.nameAr
        nameEnLabel.text = subCategoryModel.nameEn
        categoryOrLocationID.text = "\(subCategoryModel.categoryID ?? 0)"
        categoryOrLocationCode.text = subCategoryModel.categoryCode
        categoryOrLocationNameEN.text = subCategoryModel.categoryNameEn
        categoryOrLocationNameAR.text = subCategoryModel.categoryNameAr
        
        
    }
    
    func configure(subLocationModel: SubLocationModelData) {
        categoryLocationIDStaticLabel.text = "Location ID:"
        categoryLocationCodeStatic.text = "Location Code:"
        categoryLocationNameENStatic.text = "Location Name EN:"
        categoryLocationNameARStatic.text = "Location Name AR"
        idLabel.text = "\(subLocationModel.id ?? 0)"
        codeLabel.text = subLocationModel.code
        nameArLabel.text = subLocationModel.nameAr
        nameEnLabel.text = subLocationModel.nameEn
        categoryOrLocationID.text = "\(subLocationModel.locationID ?? 0)"
        categoryOrLocationCode.text = subLocationModel.locationCode
        categoryOrLocationNameEN.text = subLocationModel.locationNameEn
        categoryOrLocationNameAR.text = subLocationModel.locationNameAr
        
        
    }
    
}
