//
//  FilterSheetViewController.swift
//  Asset Manager
//
//  Created by Marwan on 22/06/2022.
//

import UIKit

enum FilterOpenedFrom {
    case category
    case location
    case vendor
    case user
}

class FilterSheetViewController: UIViewController {
    
    @IBOutlet weak var assetNameTF: UITextField!
    @IBOutlet weak var nameStaticLabel: UILabel!
    
    var didTapSearchFilter: (([String: Any]) -> ())?
    var didTapSearchQR: (() -> ())?
    var didTapResetFilter: (() -> ())?
    
    var openedFrom: FilterOpenedFrom!
    var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        assetNameTF.text = filters["name"] as? String
        
        switch openedFrom {
        case .category:
            assetNameTF.placeholder = "enter category code"
            nameStaticLabel.text = "Category Code"
        case .location:
            assetNameTF.placeholder = "enter location code"
            nameStaticLabel.text = "Location Code"
        case .vendor:
            assetNameTF.placeholder = "enter vendor name"
            nameStaticLabel.text = "Vendor Name"
        case .user:
            assetNameTF.placeholder = "enter user name"
            nameStaticLabel.text = "User Name"
        case .none:
            break
        }
        
    }

    @IBAction func searchWithFilterTapped(_ sender: UIButton) {
        guard let name = assetNameTF.text, !name.isEmpty else { return }
        filters["name"] = name
        didTapSearchFilter?(filters)
    }
    
    @IBAction func resetFilterTapped(_ sender: UIButton) {
        filters = [:]
        didTapResetFilter?()
        dismiss(animated: true)
    }

    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
