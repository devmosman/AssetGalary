//
//  DashboardTVCell.swift
//  Asset Manager
//
//  Created by Marwan on 30/07/2022.
//

import UIKit

class DashboardTVCell: UITableViewCell {
    

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var itemsTVHeight: NSLayoutConstraint!
    
    
    private var assetsList: [AssetDashboard] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(DashboardAssetTVCell.nib, forCellReuseIdentifier: DashboardAssetTVCell.identifier)
        itemsTV.rowHeight = 135
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(assets: [AssetDashboard]) {
        assetsList = assets
        itemsTV.reloadData()
        itemsTVHeight.constant = itemsTV.contentSize.height
    }
    
}

extension DashboardTVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardAssetTVCell.identifier, for: indexPath) as! DashboardAssetTVCell
        cell.configureCell(asset: assetsList[indexPath.row])
        return cell
    }
    
    
    
}
