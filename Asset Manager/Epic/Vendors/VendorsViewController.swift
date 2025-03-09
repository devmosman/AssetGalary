//
//  VendorsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class VendorsViewController: BaseViewController {

    @IBOutlet weak var itemsTV: UITableView!
    private var vendorsList = [VendorModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }

    private var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Artists"
        setupTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchVendors(filters: [:])
    }
    
    let viewModel = VendorsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchVendors = { [weak self] (vendors,isPaging) in
            if isPaging {
                self?.vendorsList.append(contentsOf: vendors)
            } else {
                self?.vendorsList = vendors                
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
        filtersVC.openedFrom = .vendor
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchVendors(filters: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchVendors(filters: [:])
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
        let addVendorVC = AddEditVendorsViewController.instantiateAddUser()
        addVendorVC.modalPresentationStyle = .fullScreen
        present(addVendorVC, animated: true)
    }

    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 165
        itemsTV.register(VendorsTVCell.nib, forCellReuseIdentifier: VendorsTVCell.identifier)
    }

}

extension VendorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VendorsTVCell.identifier, for: indexPath) as! VendorsTVCell
        cell.configure(vendorModel: vendorsList[indexPath.row])
        
        if indexPath.row == vendorsList.count - 1, vendorsList.count < viewModel.totalVendors, !viewModel.isPaginating {
            viewModel.fetchVendors(filters: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVendorVC = AddEditVendorsViewController.instantiateEditUser(vendor: vendorsList[indexPath.row])
        addVendorVC.modalPresentationStyle = .fullScreen
        present(addVendorVC, animated: true)
    }
    
}
