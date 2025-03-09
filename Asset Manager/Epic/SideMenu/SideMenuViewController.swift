//
//  SideMenuViewController.swift
//  Buzzer
//
//  Created by Marwan on 30/05/2022.
//

import UIKit
import SideMenuSwift

class SideMenuViewController: UIViewController {
    
    
    private var sideMenuItems = [SideMenuItem]()
    
    @IBOutlet weak var itemsTV: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        sideMenuItems = LocalData().isAdmin ? SideMenuItem.allCases : [.categories, .subCategories, .Location, .subLocations, .Vendor, .resetPassword]
        itemsTV.reloadData()
    }
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(SideMenuTVCell.nib, forCellReuseIdentifier: SideMenuTVCell.identifier)
        itemsTV.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func navigateTo(_ sideMenuItem: SideMenuItem) {
        sideMenuController?.hideMenu()
        if let navVC = sideMenuController?.contentViewController as? UINavigationController,
           let assetVC = navVC.viewControllers.first as? AssetsViewController {
            switch sideMenuItem {
            case .categories:
                let categoriesVC = CategoriesViewController()
                navVC.pushViewController(categoriesVC, animated: true)
            case .subCategories:
                let subcategoriesVC = SubCategoriesViewController()
                navVC.pushViewController(subcategoriesVC, animated: true)
            case .Location:
                let locationsVC = LocationsViewController()
                navVC.pushViewController(locationsVC, animated: true)
            case .subLocations:
                let sublocationVC = SubLocationsViewController()
                navVC.pushViewController(sublocationVC, animated: true)
            case .Vendor:
                let vendorsVC = VendorsViewController()
                navVC.pushViewController(vendorsVC, animated: true)
            case .Users:
                let usersVC = UsersViewController()
                navVC.pushViewController(usersVC, animated: true)
            case .dashboard:
                let dashboardVC = DashboardViewController()
                navVC.pushViewController(dashboardVC, animated: true)
            case .resetPassword:
                let resetPasswordVC = ResetPasswordViewController()
                navVC.pushViewController(resetPasswordVC, animated: true)
            case .settings:
                let settingsVC  = SettingsViewController()
                navVC.pushViewController(settingsVC, animated: true)
            case .logout:
                assetVC.logout()
            }
        }
        
    }


}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTVCell.identifier, for: indexPath) as! SideMenuTVCell
        cell.configureCell(sideMenuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateTo(sideMenuItems[indexPath.row])
    }
    
    
}
