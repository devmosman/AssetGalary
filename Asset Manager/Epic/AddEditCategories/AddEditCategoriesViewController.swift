//
//  AddEditCategoriesViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class AddEditCategoriesViewController: BaseViewController {
    
    private var state: AddEditState = .add
    private var category: CategoryModelData?
    
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


    static func instantiateAddUser() -> AddEditCategoriesViewController {
        let vc = AddEditCategoriesViewController()
        return vc
    }
    
    static func instantiateEditUser(category: CategoryModelData) -> AddEditCategoriesViewController {
        let vc = AddEditCategoriesViewController()
        vc.state = .edit
        vc.category = category
        return vc
    }
    
    let viewModel = AddEditCategoriesViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didAddUpdateCategory = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit Category" : "Add New Category"
        
        nameARView.makeShadowsAndCorners(cornerRadius: 7)
        nameARView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        nameENView.makeShadowsAndCorners(cornerRadius: 7)
        nameENView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        codeView.makeShadowsAndCorners(cornerRadius: 7)
        codeView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
    }
    
    private func setupData() {
        guard state == .edit, let category = category else { return }
        nameARTF.text = category.nameAr
        nameENTF.text = category.nameEn
        codeTF.text = category.code
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addCategory()
        } else {
            updateCategory()
        }
    }
    
    private func addCategory() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let code = codeTF.text else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.addCategory(code: code, nameAR: nameAr, nameEN: nameEn)
    }
    
    private func updateCategory() {
        guard let nameEn = nameENTF.text, let nameAr = nameARTF.text, let code = codeTF.text, let id = category?.id else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.updateCategory(id: id, code: code, nameAR: nameAr, nameEN: nameEn)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
