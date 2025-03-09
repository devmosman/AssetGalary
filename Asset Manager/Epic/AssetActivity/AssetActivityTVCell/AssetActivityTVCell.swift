//
//  AssetActivityTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 29/07/2022.
//

import UIKit

class AssetActivityTVCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(activity: AssetActivityModelElement) {
        
        usernameLabel.text = activity.userName
        activityLabel.text = (activity.actionDescription ?? "") + "\n" + (activity.detailInfo ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        dateFormatter.timeZone = .init(abbreviation: "GMT")
        if let actionDate = activity.actionDate, let date = dateFormatter.date(from: actionDate) {
            dateLabel.text = date.timeAgoDisplay()
        }
    }
    
}
