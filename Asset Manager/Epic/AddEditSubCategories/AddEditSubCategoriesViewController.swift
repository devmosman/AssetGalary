//
//  AddEditSubCategoriesViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit

class AddEditSubCategoriesViewController: BaseViewController {

    private var state: AddEditState = .add
    private var subCategory: SubCategoryModelData?
    private var categoriesList = [CategoryModelData]()
    private var selectedCategoryID: Int?
    
    @IBOutlet weak var nameENView: UIView!
    @IBOutlet weak var nameARView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var categoryIDView: UIView!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameENTF: UITextField!
    @IBOutlet weak var nameARTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        viewModel.fetchCategories()
    }


    static func instantiateAddUser() -> AddEditSubCategoriesViewController {
        let vc = AddEditSubCategoriesViewController()
        return vc
    }
    
    static func instantiateEditUser(subCategory: SubCategoryModelData) -> AddEditSubCategoriesViewController {
        let vc = AddEditSubCategoriesViewController()
        vc.state = .edit
        vc.subCategory = subCategory
        return vc
    }
    
    let viewModel = AddEditSubCategoriesViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchCategories = { [weak self] categories in
            self?.categoriesList = categories
            self?.setupData(categoiesList: categories)
        }
        
        viewModel.didAddUpdateSubCategory = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit SubCategory" : "Add New SubCategory"
        
        nameARView.makeShadowsAndCorners(cornerRadius: 7)
        nameARView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        nameENView.makeShadowsAndCorners(cornerRadius: 7)
        nameENView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        codeView.makeShadowsAndCorners(cornerRadius: 7)
        codeView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        categoryIDView.makeShadowsAndCorners(cornerRadius: 7)
        categoryIDView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        categoryIDView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryPicker)))
    }
    
    @objc func openCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = categoriesList.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            self?.categoryLabel.textColor = .black
            self?.selectedCategoryID = id
            
            self?.categoryLabel.text = value
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
        }
        picker.show(vc: self, array: array, selectedID: selectedCategoryID, title: "Categories")
        
    }
    
    private func setupData(categoiesList: [CategoryModelData]) {
        if state == .edit, let subCategory = subCategory {
            nameARTF.text = subCategory.nameAr
            nameENTF.text = subCategory.nameEn
            codeTF.text = subCategory.code
            selectedCategoryID = subCategory.categoryID
            categoryLabel.text = (categoiesList.first(where: { $0.id == subCategory.categoryID })?.nameEn ?? "") + " - " + (categoiesList.first(where: { $0.id == subCategory.categoryID })?.nameAr ?? "")
            categoryLabel.textColor = .black
        }
        
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addSubCategory()
        } else {
            updateSubCategory()
        }
    }
    
    private func addSubCategory() {
        guard let nameEn = nameENTF.text,
              let nameAr = nameARTF.text,
              let code = codeTF.text,
              let selectedCategoryID = selectedCategoryID else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.addSubCategory(code: code, nameAR: nameAr, nameEN: nameEn, categoryID: selectedCategoryID)
    }
    
    private func updateSubCategory() {
        guard let nameEn = nameENTF.text,
              let nameAr = nameARTF.text,
              let code = codeTF.text,
              let id = subCategory?.id,
              let selectedCategoryID = selectedCategoryID else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.updateSubCategory(id: id, code: code, nameAR: nameAr, nameEN: nameEn, categoryID: selectedCategoryID)
    }
    
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
