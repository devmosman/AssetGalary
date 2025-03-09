//
//  SettingsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 21/07/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var baseUrlTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        baseUrlTF.text = LocalData().baseURL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        guard let text = baseUrlTF.text, !text.isEmpty else { return }
        LocalData().baseURL = text
        navigationController?.popViewController(animated: true)
    }
    
    

}
