//
//  AddEditVendorsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class AddEditVendorsViewController: BaseViewController {

    private var state: AddEditState = .add
    private var vendor: VendorModelData?
    
    @IBOutlet weak var nameENView: UIView!
    @IBOutlet weak var nameARView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var notesView: UIView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameENTF: UITextField!
    @IBOutlet weak var nameARTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var notesTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        bind()
    }


    static func instantiateAddUser() -> AddEditVendorsViewController {
        let vc = AddEditVendorsViewController()
        return vc
    }
    
    static func instantiateEditUser(vendor: VendorModelData) -> AddEditVendorsViewController {
        let vc = AddEditVendorsViewController()
        vc.state = .edit
        vc.vendor = vendor
        return vc
    }
    
    let viewModel = AddEditVendorsViewModel()
    func bind() {
        
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didAddUpdateVendor = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit Vendor" : "Add New Vendor"
        
        nameARView.makeShadowsAndCorners(cornerRadius: 7)
        nameARView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        nameENView.makeShadowsAndCorners(cornerRadius: 7)
        nameENView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        codeView.makeShadowsAndCorners(cornerRadius: 7)
        codeView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        notesView.makeShadowsAndCorners(cornerRadius: 7)
        notesView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
    }
    
    private func setupData() {
        guard state == .edit, let vendor = vendor else { return }
        nameARTF.text = vendor.nameAr
        nameENTF.text = vendor.nameEn
        addressTF.text = vendor.address
        notesTF.text = vendor.notes
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addVendor()
        } else {
            updateVendor()
        }
    }
    
    private func addVendor() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let address = addressTF.text else {
            showAlert(message: "Please fill in all fields")
            return
        }
        let notes = notesTF.text ?? ""
        viewModel.addVendor(address: address, nameAR: nameAr, nameEN: nameEn, notes: notes)
    }

    private func updateVendor() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let address = addressTF.text, let id = vendor?.id else {
            showAlert(message: "Please fill in all fields")
            return
        }
        let notes = notesTF.text ?? ""
        viewModel.updateVendor(id: id, address: address, nameAR: nameAr, nameEN: nameEn, notes: notes)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
