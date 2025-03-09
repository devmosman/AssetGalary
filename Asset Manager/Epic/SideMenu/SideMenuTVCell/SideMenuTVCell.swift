//
//  SideMenuTVCell.swift
//  Buzzer
//
//  Created by Marwan on 30/05/2022.
//

import UIKit

class SideMenuTVCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ item: SideMenuItem) {
        itemTitleLabel.text = item.title
        if item == .logout { itemTitleLabel.textColor = .red }
    }
    
}
