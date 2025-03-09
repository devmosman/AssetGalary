//
//  AssetActivityViewController.swift
//  Asset Manager
//
//  Created by Marwan on 29/07/2022.
//

import UIKit

class AssetActivityViewController: UIViewController {
    
    
    @IBOutlet weak var itemsTV: UITableView!
    
    var activityList: [AssetActivityModelElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        sheetViewController?.handleScrollView(itemsTV)
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(AssetActivityTVCell.nib, forCellReuseIdentifier: AssetActivityTVCell.identifier)
        itemsTV.rowHeight = 110
        
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension AssetActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetActivityTVCell.identifier, for: indexPath) as! AssetActivityTVCell
        cell.configureCell(activity: activityList[indexPath.row])
        return cell
    }
    
    
}
