//
//  AddEditSubLocationsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class AddEditSubLocationsViewController: BaseViewController {

    private var state: AddEditState = .add
    private var subLocation: SubLocationModelData?
    private var locationList = [LocationModelData]()
    private var selectedLocationID: Int?
    
    
    @IBOutlet weak var nameENView: UIView!
    @IBOutlet weak var nameARView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var locationIDView: UIView!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameENTF: UITextField!
    @IBOutlet weak var nameARTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        viewModel.fetchLocation()
    }


    static func instantiateAddUser() -> AddEditSubLocationsViewController {
        let vc = AddEditSubLocationsViewController()
        return vc
    }
    
    static func instantiateEditUser(subLocation: SubLocationModelData) -> AddEditSubLocationsViewController {
        let vc = AddEditSubLocationsViewController()
        vc.state = .edit
        vc.subLocation = subLocation
        return vc
    }
    
    let viewModel = AddEditSubLocationsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchLocations = { [weak self] locations in
            self?.locationList = locations
            self?.setupData(locationList: locations)
        }
        
        viewModel.didAddUpdateSubLocation = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit SubLocation" : "Add New SubLocation"
        
        nameARView.makeShadowsAndCorners(cornerRadius: 7)
        nameARView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        nameENView.makeShadowsAndCorners(cornerRadius: 7)
        nameENView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        codeView.makeShadowsAndCorners(cornerRadius: 7)
        codeView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        locationIDView.makeShadowsAndCorners(cornerRadius: 7)
        locationIDView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        locationIDView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLocationPicker)))
        
    }
    
    @objc func openLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = locationList.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.locationLabel.textColor = .black
            self?.selectedLocationID = id
            
            self?.locationLabel.text = value
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedLocationID, title: "Categories")
        
    }
    
    private func setupData(locationList: [LocationModelData]) {
        if state == .edit, let subLocation = subLocation {
            nameARTF.text = subLocation.nameAr
            nameENTF.text = subLocation.nameEn
            codeTF.text = subLocation.code
            selectedLocationID = subLocation.locationID
            locationLabel.text = (locationList.first(where: { $0.id == subLocation.locationID })?.nameEn ?? "") + " - " + (locationList.first(where: { $0.id == subLocation.locationID })?.nameAr ?? "")
            locationLabel.textColor = .black
        }
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addSubLocation()
        } else {
            updateSubLocation()
        }
    }
    
    private func addSubLocation() {
        guard let nameEn = nameENTF.text,
              let nameAr = nameARTF.text,
              let code = codeTF.text,
              let selectedLocationID = selectedLocationID else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.addSubLocation(code: code, nameAR: nameAr, nameEN: nameEn, locationID: selectedLocationID)
    }
    
    private func updateSubLocation() {
        guard let nameEn = nameENTF.text,
              let nameAr = nameARTF.text,
              let code = codeTF.text,
              let id = subLocation?.id,
              let selectedLocationID = selectedLocationID else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.updateSubLocation(id: id, code: code, nameAR: nameAr, nameEN: nameEn, locationID: selectedLocationID)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
