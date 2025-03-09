//
//  LocationsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class LocationsViewController: BaseViewController {
    
    @IBOutlet weak var itemsTV: UITableView!

    private var locationsList = [LocationModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Locations"
        setupTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchLocations(filter: [:])
    }
    
    let viewModel = LocationsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchLocations = { [weak self] (locations, isPaging) in
            if isPaging {
                self?.locationsList.append(contentsOf: locations)
            } else {
                self?.locationsList = locations
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
        filtersVC.openedFrom = .location
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchLocations(filter: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchLocations(filter: [:])
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
        let addLocationVC = AddEditLocationsViewController.instantiateAddUser()
        addLocationVC.modalPresentationStyle = .fullScreen
        present(addLocationVC, animated: true)
    }


    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 135
        itemsTV.register(CategoriesTVCell.nib, forCellReuseIdentifier: CategoriesTVCell.identifier)
    }

}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTVCell.identifier, for: indexPath) as! CategoriesTVCell
        let location = locationsList[indexPath.row]
        cell.configure(locationModel: location)
        
        if indexPath.row == locationsList.count - 1, locationsList.count < viewModel.totalLocations, !viewModel.isPaginating {
            viewModel.fetchLocations(filter: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addLocationVC = AddEditLocationsViewController.instantiateEditUser(locationModel: locationsList[indexPath.row])
        addLocationVC.modalPresentationStyle = .fullScreen
        present(addLocationVC, animated: true)
    }
    
}
