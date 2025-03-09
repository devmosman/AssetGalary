//
//  BaseViewController.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.15)
        view.alpha = 0
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.color = .white
        ai.style = .whiteLarge
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        let square = UIView()
        square.backgroundColor = .black.withAlphaComponent(0.7)
        square.layer.cornerRadius = 10
        square.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(square)
        square.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        square.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        square.heightAnchor.constraint(equalToConstant: 80).isActive = true
        square.widthAnchor.constraint(equalToConstant: 80).isActive = true

        view.addSubview(ai)
        ai.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ai.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func startLoading(_ isLoading: Bool) {
        view.isUserInteractionEnabled = isLoading ? false : true
        loadingView.alpha = isLoading ? 1 : 0
    }
    

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Asset Manager", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = []
        present(alert, animated: true)
    }
    
    func logout() {
        let alert = UIAlertController(title: "Asset Manager", message: "Do you really want to logout ?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
            DispatchQueue.main.async {
                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                LocalData().authToken = ""
                let navController = UINavigationController(rootViewController: LoginViewController())
                navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navController.navigationBar.shadowImage = UIImage()
                navController.navigationBar.tintColor = .black
                navController.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
                ]
                appDel.window!.rootViewController = navController
                appDel.window!.makeKeyAndVisible()
            }
        }
        let noAction = UIAlertAction(title: "NO", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }

}
