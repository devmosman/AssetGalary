//
//  LoginViewController.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit
import SideMenuSwift

class LoginViewController: BaseViewController {
    
    
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        #if DEBUG
        emailTF.text = "admin"
        passwordTF.text = "123456"
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didSuccessfullyLogin = { [weak self] user in
            LocalData().authToken = user.accessToken
            if user.user.role.contains("Admin") || user.user.role.contains("admin") || user.user.role.contains("Administrator") || user.user.role.contains("administrator") {
                LocalData().isAdmin = true
            }
            self?.goToAssets()
            
        }
    }
    
    private func goToAssets() {
        guard let appDel:AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let navController = UINavigationController(rootViewController: AssetsViewController())
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .black
        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        let sideMenuVC = SideMenuViewController()
        let sideMenuController = SideMenuController(contentViewController: navController, menuViewController: sideMenuVC)
        appDel.window!.rootViewController = sideMenuController
        appDel.window!.makeKeyAndVisible()
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTF.text,
              let password = passwordTF.text else {
            showAlert(message: "Please fill in all fields")
            return
        }
        viewModel.login(username: email, password: password)
    }
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
