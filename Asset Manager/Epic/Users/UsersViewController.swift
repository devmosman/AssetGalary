//
//  UsersViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class UsersViewController: BaseViewController {
    
    @IBOutlet weak var itemsTV: UITableView!
    private var usersList = [UserModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Management"
        setupTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchUsers(filter: [:])
    }
    
    let viewModel = UsersViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchUsers = { [weak self] (users,isPaging) in
            if isPaging {
                self?.usersList.append(contentsOf: users)
            } else {
                self?.usersList = users
            }
            
        }
    }
    
    private func setupUI() {
        let add = UIButton()
        add.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        add.setImage(UIImage(named: "plus"), for: .normal)
        add.frame = .init(x: 0, y: 0, width: 25, height: 25)
        let addButton = UIBarButtonItem(customView: add)
        let filter = UIButton()
        filter.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        filter.setImage(UIImage(named: "filter"), for: .normal)
        filter.frame = .init(x: 0, y: 0, width: 25, height: 25)
        let filterButton = UIBarButtonItem(customView: filter)
        navigationItem.rightBarButtonItems = [addButton, filterButton]
    }
    
    @objc func filterTapped() {
        let filtersVC = FilterSheetViewController()
        filtersVC.filters = filters
        filtersVC.openedFrom = .user
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchUsers(filter: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchUsers(filter: [:])
        }
        
        
        let sheetOptions = SheetOptions(pullBarHeight: 10, presentingViewCornerRadius: 20, shouldExtendBackground: true, setIntrinsicHeightOnNavigationControllers: nil, useFullScreenMode: false, shrinkPresentingViewController: true, useInlineMode: false, horizontalPadding: 0, maxWidth: nil)
        let sheetVC = SheetViewController(controller: filtersVC, sizes: [.fixed(500)], options: sheetOptions)
        sheetVC.gripColor = .clear
        sheetVC.cornerRadius = 20
        sheetVC.pullBarBackgroundColor = UIColor.clear
        sheetVC.dismissOnPull = true
        sheetVC.dismissOnOverlayTap = true
        self.present(sheetVC, animated: true)
    }

    @objc func addButtonTapped() {
        let addUserVC = AddEditUserViewController.instantiateAddUser()
        addUserVC.modalPresentationStyle = .fullScreen
        present(addUserVC, animated: true)
    }
    
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 275
        itemsTV.register(UsersTVCell.nib, forCellReuseIdentifier: UsersTVCell.identifier)
    }
    


}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTVCell.identifier, for: indexPath) as! UsersTVCell
        cell.configure(userModel: usersList[indexPath.row])
        
        if indexPath.row == usersList.count - 1, usersList.count < viewModel.totalUsers, !viewModel.isPaginating {
            viewModel.fetchUsers(filter: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editUserVC = AddEditUserViewController.instantiateEditUser(user: usersList[indexPath.row])
        editUserVC.modalPresentationStyle = .fullScreen
        present(editUserVC, animated: true)
    }
    
}
