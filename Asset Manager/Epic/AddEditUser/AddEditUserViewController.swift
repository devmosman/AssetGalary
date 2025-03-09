//
//  AddEditUserViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import iOSDropDown

enum AddEditState {
    case add
    case edit
}

class AddEditUserViewController: BaseViewController {
    
    
    
    private var state: AddEditState = .add
    private var user: UserModelData?

    
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var shortNameView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userRoleView: UIView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var shortNameTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var userRoleLabel: UILabel!
    
    @IBOutlet weak var isActiveButton: UIButton!
    
    
    static func instantiateAddUser() -> AddEditUserViewController {
        let vc = AddEditUserViewController()
        return vc
    }
    
    static func instantiateEditUser(user: UserModelData) -> AddEditUserViewController {
        let vc = AddEditUserViewController()
        vc.state = .edit
        vc.user = user
        return vc
    }

    
    var isUserActive = 0
    var userRoleSelectedID: Int?
    var userRole: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
        bind()
    }
    
    let viewModel = AddEditUserViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didAddUpdateUser = { [weak self] _ in
            self?.dismiss(animated: true)
        }

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit User" : "Add New User"
        
        fullNameView.makeShadowsAndCorners(cornerRadius: 7)
        fullNameView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        shortNameView.makeShadowsAndCorners(cornerRadius: 7)
        shortNameView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        userNameView.makeShadowsAndCorners(cornerRadius: 7)
        userNameView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        mobileNumberView.makeShadowsAndCorners(cornerRadius: 7)
        mobileNumberView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        emailView.makeShadowsAndCorners(cornerRadius: 7)
        emailView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        passwordView.makeShadowsAndCorners(cornerRadius: 7)
        passwordView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        userRoleView.makeShadowsAndCorners(cornerRadius: 7)
        userRoleView.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        
        userRoleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserRolePicker)))
        
    }
    
    
    @objc func openUserRolePicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = [.init(name: "Administrator", id: 1), .init(name: "User", id: 2)]
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.userRoleLabel.textColor = .black
            self?.userRoleLabel.text = value
            self?.userRole = value
            self?.userRoleSelectedID = id
        }
        picker.show(vc: self, array: array, selectedID: userRoleSelectedID, title: "User-Roles")
    }
    
    private func setupData() {
        guard state == .edit, let user = user else { return }
        fullNameTF.text = user.fullName
        shortNameTF.text = user.shortName
        userNameTF.text = user.userName
        mobileNumberTF.text = user.mobile
        emailTF.text = user.email
        passwordTF.text = user.password
        isActiveButton.isSelected = user.status == 0 ? false : true
        isUserActive = user.status ?? 0
        if let userRole = user.userRole {
            if userRole == "Administrator" {
                userRoleSelectedID = 1
                userRoleLabel.text = "Administrator"
                userRoleLabel.textColor = .black
                self.userRole = "Administrator"
            } else if userRole == "User" {
                userRoleSelectedID = 2
                userRoleLabel.text = "User"
                userRoleLabel.textColor = .black
                self.userRole = "User"
            }
        }
    }
    
    
    @IBAction func activeBtnTapped(_ seneder: UIButton){
        if isActiveButton.isSelected {
            isUserActive = 0
        } else {
            isUserActive = 1
        }
        isActiveButton.isSelected.toggle()
    }
    

    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addUser()
        } else {
            updateUser()
        }
    }
    
    private func addUser() {
        guard let fullname = fullNameTF.text, !fullname.isEmpty,
              let shortname = shortNameTF.text, !shortname.isEmpty,
              let username = userNameTF.text, !username.isEmpty,
              let mobile = mobileNumberTF.text, !mobile.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let userRole = userRole else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.addUser(userName: username, password: password, email: email, mobile: mobile, fullName: fullname, shortName: shortname, status: isUserActive, role: userRole)
    }
    
    private func updateUser() {
        guard let fullname = fullNameTF.text, !fullname.isEmpty,
              let shortname = shortNameTF.text, !shortname.isEmpty,
              let username = userNameTF.text, !username.isEmpty,
              let mobile = mobileNumberTF.text, !mobile.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let id = user?.id,
              let userRole = userRole else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.updateUser(id: id, userName: username, password: password, email: email, mobile: mobile, fullName: fullname, shortName: shortname, status: isUserActive, role: userRole)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}
