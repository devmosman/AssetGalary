//
//  VendorsTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class VendorsTVCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameArLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
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
    
    func configure(vendorModel: VendorModelData) {
        idLabel.text = "\(vendorModel.id ?? 0)"
        nameArLabel.text = vendorModel.nameAr
        nameEnLabel.text = vendorModel.nameEn
        addressLabel.text = vendorModel.address ?? " - "
        notesLabel.text = vendorModel.notes ?? " - "
    }
    
}
