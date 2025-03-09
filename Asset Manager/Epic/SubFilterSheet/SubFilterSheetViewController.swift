//
//  SubFilterSheetViewController.swift
//  Asset Manager
//
//  Created by Marwan on 22/06/2022.
//

import UIKit

enum SubFilterOpenedFrom {
    case subCategory
    case subLocation
}

class SubFilterSheetViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameStaticLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idStaticLabel: UILabel!
    @IBOutlet weak var idLabelBgView: UIView!
    
    var categories : [CategoryModelData] = []
    var locations : [LocationModelData] = []
    var selectedID: Int?
    var didTapSearchFilter: (([String: Any]) -> ())?
    var didTapSearchQR: (() -> ())?
    var didTapResetFilter: (() -> ())?
    
    var openedFrom: SubFilterOpenedFrom!
    var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.text = filters["name"] as? String
        idLabel.text = filters["id"] as? String
        
        switch openedFrom {
        case .subCategory:
            nameTF.placeholder = "enter sub-category code"
            nameStaticLabel.text = "Sub-Category Code"
            idStaticLabel.text = "Category"
            idLabel.text = "category..."
            idLabelBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryPicker)))
            
            if let selectedIDStr = filters["id"] as? String, let id = Int(selectedIDStr) {
                selectedID = id
                idLabel.text = (categories.first(where: { $0.id == id })?.nameEn ?? "") + " - " + (categories.first(where: { $0.id == id })?.nameAr ?? "")
                idLabel.textColor = .black
            }
            
            
        case .subLocation:
            nameTF.placeholder = "enter sub-location code"
            nameStaticLabel.text = "Sub-Location Code"
            idStaticLabel.text = "Location"
            idLabelBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLocationPicker)))
            idLabel.text = "location..."
            if let selectedIDStr = filters["id"] as? String, let id = Int(selectedIDStr) {
                selectedID = id
                idLabel.text = (locations.first(where: { $0.id == id })?.nameEn ?? "") + " - " + (locations.first(where: { $0.id == id })?.nameAr ?? "")
                idLabel.textColor = .black
            }
        case .none:
            break
        }
    }
    
    @objc func openCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = categories.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.idLabel.textColor = .black
            self?.selectedID = id
            self?.filters["id"] = "\(id)"
            self?.idLabel.text = value
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedID, title: "Categories")
        
    }
    
    @objc func openLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = locations.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.idLabel.textColor = .black
            self?.selectedID = id
            self?.filters["id"] = "\(id)"
            self?.idLabel.text = value
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedID, title: "Locations")
        
    }
    
    @IBAction func searchWithFilterTapped(_ sender: UIButton) {
        if let name = nameTF.text, !name.isEmpty {
            filters["name"] = name
        }
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
