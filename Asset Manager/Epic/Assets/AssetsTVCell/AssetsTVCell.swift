//
//  AssetsTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit


protocol AssetsTVCell_Delegate {
   func deleteAssets_didSelect(AssetsId: Int)
}
class AssetsTVCell: UITableViewCell {
    
    
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var galleryDescriptionLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    var delegate: AssetsTVCell_Delegate?
    var assetsId:Int?
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
    
    
   
    
    func configure(assetModel: AssetModelData) {
        assetNameLabel.text = assetModel.discription
        modelNameLabel.text = assetModel.model
        galleryDescriptionLabel.text = assetModel.galleryDescription
        codeLabel.text = assetModel.code
        serialNumberLabel.text = assetModel.serialNumber
    }
    
    func configure(assetByIDModel: AssetByIDModel?) {
        assetNameLabel.text = assetByIDModel?.discription
        modelNameLabel.text = assetByIDModel?.model
        galleryDescriptionLabel.text = assetByIDModel?.galleryDescription
        codeLabel.text = assetByIDModel?.code
        serialNumberLabel.text = assetByIDModel?.serialNumber
    }
    
    @IBAction func deleteAssetsActionTapped(_ sender: UIButton) {
        delegate?.deleteAssets_didSelect(AssetsId: assetsId!)
    }
    
}
