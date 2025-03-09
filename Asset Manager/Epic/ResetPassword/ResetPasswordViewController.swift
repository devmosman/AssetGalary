//
//  ResetPasswordViewController.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var newpasswordContainer: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var newpasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reset Password"
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    let viewModel = ResetPasswordViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didResetPassword = { [weak self] user in
            self?.navigationController?.popViewController(animated: true)
            
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let username = usernameTF.text,
              let newpassword = newpasswordTF.text else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.resetPassword(username: username, newPassword: newpassword)
        
    }

}
