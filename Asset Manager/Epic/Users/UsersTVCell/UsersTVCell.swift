//
//  UsersTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class UsersTVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shortnameLabel: UILabel!
    @IBOutlet weak var userroleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
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
    
    func configure(userModel: UserModelData) {
        idLabel.text = "\(userModel.id ?? 0)"
        emailLabel.text = userModel.email
        passwordLabel.text = userModel.password
        mobileLabel.text = userModel.mobile
        fullnameLabel.text = userModel.fullName
        statusLabel.text = userModel.status == 0 ? "in active" : "active"
        shortnameLabel.text = userModel.shortName
        userroleLabel.text = userModel.userRole
        usernameLabel.text = userModel.userName
        
        
    }
    
}
