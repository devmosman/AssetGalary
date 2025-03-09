//
//  DashboardAssetTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 30/07/2022.
//

import UIKit

class DashboardAssetTVCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameArLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
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
    
    
    func configureCell(asset: AssetDashboard) {
        nameArLabel.text = asset.nameAr
        nameEnLabel.text = asset.nameEn
        codeLabel.text = asset.code
        quantityLabel.text = "\(asset.total ?? 0)"
        totalPriceLabel.text = "\(asset.totalPrice ?? 0)"
    }
    
}
