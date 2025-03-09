//
//  AssetsFilterSheetViewController.swift
//  Asset Manager
//
//  Created by Marwan on 22/06/2022.
//

import UIKit

class AssetsFilterSheetViewController: BaseViewController {
    
    @IBOutlet weak var assetNameTF: UITextField!
    
    @IBOutlet weak var vendorBgView: UIView!
    @IBOutlet weak var sublocationBgView: UIView!
    @IBOutlet weak var locationBgView: UIView!
    @IBOutlet weak var subcategoryBgView: UIView!
    @IBOutlet weak var categoryBgView: UIView!
    
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sublocationLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var didTapSearchFilter: (([String: Any]) -> ())?
    var didTapSearchQR: (() -> ())?
    var didTapResetFilter: (() -> ())?
    
    var filters = [String: Any]()
    
    var categories = [CategoryModelData]()
    var locations = [LocationModelData]()
    var vendors = [VendorModelData]()
    var subCategories = [SubCategoryModelData]()
    var subLocations = [SubLocationModelData]()
    
    var firstTimeLoadSubCategories = true
    var firstTimeLoadSubLocations = true
    
    var selectedCategoryID: Int?
    var selectedSubCategoryID: Int?
    var selectedLocationID: Int?
    var selectedSubLocationID: Int?
    var selectedVendorID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sheetViewController?.handleScrollView(scrollView)
        assetNameTF.text = filters["name"] as? String
        
        categoryBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryPicker)))
        subcategoryBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSubCategoryPicker)))
        locationBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLocationPicker)))
        sublocationBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSubLocationPicker)))
        vendorBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openVendorPicker)))
        
        
        if let categoryID = Int(filters["categoryID"] as? String ?? "") {
            selectedCategoryID = categoryID
            categoryLabel.text = (categories.first(where: { $0.id == categoryID })?.nameEn ?? "") + " - " + (categories.first(where: { $0.id == categoryID })?.nameAr ?? "")
            categoryLabel.textColor = .black
            fetchSubCategories(id: categoryID)
        }
        if let locationID = Int(filters["locationID"] as? String ?? "") {
            selectedLocationID = locationID
            locationLabel.text = (locations.first(where: { $0.id == locationID })?.nameEn ?? "") + " - " + (locations.first(where: { $0.id == locationID })?.nameAr ?? "")
            locationLabel.textColor = .black
            fetchSubLocations(id: locationID)
        }
        
        if let vendorID = Int(filters["vendorID"] as? String ?? "") {
            selectedVendorID = vendorID
            vendorLabel.textColor = .black
            vendorLabel.text = (vendors.first(where: { $0.id == vendorID })?.nameEn ?? "") + " - " + (vendors.first(where: { $0.id == vendorID })?.nameAr ?? "")
        }
    }
    
    @objc func openCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = categories.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.selectedCategoryID = id
            self?.categoryLabel.textColor = .black
            self?.categoryLabel.text = value
            self?.filters["categoryID"] = "\(id)"
            self?.fetchSubCategories(id: id)
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedCategoryID, title: "Categories")
    }
    @objc func openSubCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = subCategories.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            self?.selectedSubCategoryID = id
            self?.subCategoryLabel.textColor = .black
            self?.subCategoryLabel.text = value
            self?.filters["subCategoryID"] = "\(id)"
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedSubCategoryID, title: "Sub-Categories")
    }
    @objc func openLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = locations.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.selectedLocationID = id
            self?.locationLabel.textColor = .black
            self?.locationLabel.text = value
            self?.filters["locationID"] = "\(id)"
            self?.fetchSubLocations(id: id)
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedLocationID, title: "Locations")
    }
    @objc func openSubLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = subLocations.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            self?.selectedSubLocationID = id
            self?.sublocationLabel.textColor = .black
            self?.sublocationLabel.text = value
            self?.filters["subLocationID"] = "\(id)"
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedSubLocationID, title: "Sub-Locations")
    }
    @objc func openVendorPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = vendors.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.selectedVendorID = id
            self?.vendorLabel.textColor = .black
            self?.vendorLabel.text = value
            self?.filters["vendorID"] = "\(id)"
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedVendorID, title: "Vendors")
    }
    
    private func fetchSubCategories(id: Int) {
        self.startLoading(true)
        NetworkClient().request(api: .fetchSubCategories(filter: "", page: 0, size: 1000, categoryID: "\(id)"), modelType: SubCategoryModel.self) { [weak self] result in
            guard let self = self else { return }
            self.startLoading(false)
            switch result {
            case .success(let subCategoryModel):
                self.subCategories = subCategoryModel.data ?? []
                self.setupSubCategoiesData()
            case .failure(let error):
                self.showAlert(message: error.desc)
            }
        }
    }
    
    private func setupSubCategoiesData() {
        
        selectedSubCategoryID = nil
        subCategoryLabel.text = "sub-category"
        subCategoryLabel.textColor = .lightGray
        
        if !firstTimeLoadSubCategories { filters["subCategoryID"] = nil }
        
        if self.firstTimeLoadSubCategories, let subCategoryID = Int(filters["subCategoryID"] as? String ?? "") {
            self.selectedSubCategoryID = subCategoryID
            self.subCategoryLabel.textColor = .black
            self.subCategoryLabel.text = (subCategories.first(where: { $0.id == subCategoryID })?.nameEn ?? "") + " - " + (subCategories.first(where: { $0.id == subCategoryID })?.nameAr ?? "")
        }
        self.firstTimeLoadSubCategories = false
    }
    
    func fetchSubLocations(id: Int) {
        self.startLoading(true)
        NetworkClient().request(api: .fetchSubLocations(filter: "", page: 0, size: 1000, locationID: "\(id)"), modelType: SubLocationModel.self) { [weak self] result in
            guard let self = self else { return }
            self.startLoading(false)
            switch result {
            case .success(let subLocationsModel):
                self.subLocations = subLocationsModel.data ?? []
                self.setupSubLocationsData()
            case .failure(let error):
                self.showAlert(message: error.desc)
            }
        }
    }
    
    private func setupSubLocationsData() {
        selectedSubLocationID = nil
        sublocationLabel.text = "sub-location"
        sublocationLabel.textColor = .lightGray
        
        if !firstTimeLoadSubLocations { filters["subLocationID"] = nil }
        
        if self.firstTimeLoadSubLocations, let subLocationID = Int(filters["subLocationID"] as? String ?? "") {
            self.selectedSubLocationID = subLocationID
            self.sublocationLabel.textColor = .black
            self.sublocationLabel.text = (subLocations.first(where: { $0.id == subLocationID })?.nameEn ?? "") + " - " + (subLocations.first(where: { $0.id == subLocationID })?.nameAr ?? "")
        }
        self.firstTimeLoadSubLocations = false
    }

    @IBAction func searchWithFilterTapped(_ sender: UIButton) {
        if let name = assetNameTF.text, !name.isEmpty {
            filters["name"] = name
        }
        didTapSearchFilter?(filters)
    }
    
    @IBAction func resetFilterTapped(_ sender: UIButton) {
        filters = [:]
        didTapResetFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func searchWithQRTapped(_ sender: UIButton) {
        filters = [:]
        didTapSearchQR?()
        dismiss(animated: true)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
