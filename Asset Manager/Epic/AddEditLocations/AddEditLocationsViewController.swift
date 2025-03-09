//
//  AddEditLocationsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class AddEditLocationsViewController: BaseViewController {

    private var state: AddEditState = .add
    private var location: LocationModelData?
    
    @IBOutlet weak var nameENView: UIView!
    @IBOutlet weak var nameARView: UIView!
    @IBOutlet weak var codeView: UIView!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameENTF: UITextField!
    @IBOutlet weak var nameARTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        bind()
    }


    static func instantiateAddUser() -> AddEditLocationsViewController {
        let vc = AddEditLocationsViewController()
        return vc
    }
    
    static func instantiateEditUser(locationModel: LocationModelData) -> AddEditLocationsViewController {
        let vc = AddEditLocationsViewController()
        vc.state = .edit
        vc.location = locationModel
        return vc
    }
    
    let viewModel = AddEditLocationsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didAddUpdateLocation = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit Location" : "Add New Location"
        
        nameARView.makeShadowsAndCorners(cornerRadius: 7)
        nameARView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        nameENView.makeShadowsAndCorners(cornerRadius: 7)
        nameENView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        codeView.makeShadowsAndCorners(cornerRadius: 7)
        codeView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
    }
    
    private func setupData() {
        guard state == .edit, let location = location else { return }
        nameARTF.text = location.nameAr
        nameENTF.text = location.nameEn
        codeTF.text = location.code
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addLocation()
        } else {
            updateLocation()
        }
    }
    
    private func addLocation() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let code = codeTF.text else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.addLocation(code: code, nameAR: nameAr, nameEN: nameEn)
    }
    
    private func updateLocation() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let code = codeTF.text, let id = location?.id else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.updateLocation(id: id, code: code, nameAR: nameAr, nameEN: nameEn)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    

}
