//
//  SubLocationsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class SubLocationsViewController: BaseViewController {

    @IBOutlet weak var itemsTV: UITableView!
    private var subLocationsList = [SubLocationModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var filters = [String: Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sub Locations"
        setupTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchSubLocations(filter: [:])
    }
    
    let viewModel = SubLocationsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchSubLocations = { [weak self] (subLocations, isPaging) in
            if isPaging {
                self?.subLocationsList.append(contentsOf: subLocations)
            } else {
                self?.subLocationsList = subLocations                
            }
        }
        
        viewModel.didFetchLocations = { [weak self] locations in
            self?.openFilterScreen(locations: locations)
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
        viewModel.fetchLocations()
    }
    
    func openFilterScreen(locations: [LocationModelData]) {
        let filtersVC = SubFilterSheetViewController()
        filtersVC.filters = filters
        filtersVC.openedFrom = .subLocation
        filtersVC.locations = locations
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchSubLocations(filter: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchSubLocations(filter: [:])
        }
        
        
        let sheetOptions = SheetOptions(pullBarHeight: 10, presentingViewCornerRadius: 20, shouldExtendBackground: true, setIntrinsicHeightOnNavigationControllers: nil, useFullScreenMode: false, shrinkPresentingViewController: true, useInlineMode: false, horizontalPadding: 0, maxWidth: nil)
        let sheetVC = SheetViewController(controller: filtersVC, sizes: [.fixed(600)], options: sheetOptions)
        sheetVC.gripColor = .clear
        sheetVC.cornerRadius = 20
        sheetVC.pullBarBackgroundColor = UIColor.clear
        sheetVC.dismissOnPull = true
        sheetVC.dismissOnOverlayTap = true
        self.present(sheetVC, animated: true)
    }
    
    @objc func addButtonTapped() {
        let addSubLocationVC = AddEditSubLocationsViewController.instantiateAddUser()
        addSubLocationVC.modalPresentationStyle = .fullScreen
        present(addSubLocationVC, animated: true)
    }

    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 240
        itemsTV.register(SubCategoriesTVCell.nib, forCellReuseIdentifier: SubCategoriesTVCell.identifier)
    }

}

extension SubLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subLocationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoriesTVCell.identifier, for: indexPath) as! SubCategoriesTVCell
        let subLocation = subLocationsList[indexPath.row]
        cell.configure(subLocationModel: subLocation)
        
        if indexPath.row == subLocationsList.count - 1, subLocationsList.count < viewModel.totalSubLocations, !viewModel.isPaginating {
            viewModel.fetchSubLocations(filter: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addSubLocationVC = AddEditSubLocationsViewController.instantiateEditUser(subLocation: subLocationsList[indexPath.row])
        addSubLocationVC.modalPresentationStyle = .fullScreen
        present(addSubLocationVC, animated: true)
    }
    
}
