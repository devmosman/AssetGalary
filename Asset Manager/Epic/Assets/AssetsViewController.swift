//
//  AssetsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit
import SideMenuSwift
import FittedSheets

class AssetsViewController: BaseViewController {
    
    enum SearchType {
        case filters, qr
    }
    
    @IBOutlet weak var itemsTV: UITableView!
    
    private var filters = [String: Any]()
    private var assetsList = [AssetModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var searchFlag = SearchType.filters

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Assets"
        configureSideMenu()
        setupTableView()
        bind()
        
        print("Bearer \(LocalData().authToken)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        assetsList = []
        viewModel.fetchAssets(filters: [:])
    }
    
    let viewModel = AssetsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchAssets = { [weak self] (assets, isPaging) in
            if isPaging {
                self?.assetsList.append(contentsOf: assets)
            } else {
                self?.assetsList = assets
            }
        }
        
        viewModel.didFetchAssetByQR = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.assetByQR == nil {
                self.searchFlag = .filters
                self.itemsTV.reloadData()
            } else {
                self.searchFlag = .qr
                self.itemsTV.reloadData()
            }
        }
        
        viewModel.didLoadLookupData = { [weak self] in
            self?.openFilter()
        }
//        viewModel.didDeleteSuccess = { [weak self] loading in
//            assetsList = []
//            viewModel.fetchAssets(filters: [:])
//        }
       
        
        viewModel.didDeleteSuccess = { [weak self] Success in
            if Success {
                self!.assetsList = []
                self!.viewModel.fetchAssets(filters: [:])
            }
        }
    }
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 140
        itemsTV.register(AssetsTVCell.nib, forCellReuseIdentifier: AssetsTVCell.identifier)
        itemsTV.layer.shadowColor = UIColor.black.cgColor
        itemsTV.layer.shadowRadius = 4
        itemsTV.layer.shadowOpacity = 0.1
    }
    
    
    @IBAction func addAssetButtonTapped(_ sender: UIButton) {
        let addAssetVC = AddEditAssetsViewController.instantiateAddUser()
        addAssetVC.modalPresentationStyle = .fullScreen
        present(addAssetVC, animated: true)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        if viewModel.locations.isEmpty, viewModel.categories.isEmpty, viewModel.vendors.isEmpty {
            viewModel.fetchCategories()
            viewModel.fetchLocations()
            viewModel.fetchVendors()
        } else {
            openFilter()
        }
        
    }
    
    private func openFilter() {
        let filtersVC = AssetsFilterSheetViewController()
        filtersVC.filters = filters
        filtersVC.categories = viewModel.categories
        filtersVC.locations = viewModel.locations
        filtersVC.vendors = viewModel.vendors
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.searchFlag = .filters
            self.filters = filters
            self.viewModel.fetchAssets(filters: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.searchFlag = .filters
            self.filters = [:]
            self.viewModel.fetchAssets(filters: [:])
            self.viewModel.assetByQR = nil
        }
        
        let sheetOptions = SheetOptions(pullBarHeight: 10, presentingViewCornerRadius: 20, shouldExtendBackground: true, setIntrinsicHeightOnNavigationControllers: nil, useFullScreenMode: false, shrinkPresentingViewController: true, useInlineMode: false, horizontalPadding: 0, maxWidth: nil)
        let sheetVC = SheetViewController(controller: filtersVC, sizes: [.percent(0.85)], options: sheetOptions)
        sheetVC.gripColor = .clear
        sheetVC.cornerRadius = 20
        sheetVC.pullBarBackgroundColor = UIColor.clear
        sheetVC.dismissOnPull = true
        sheetVC.dismissOnOverlayTap = true
        self.present(sheetVC, animated: true)
    }
    
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 300
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.animation.dampingRatio = 0.8
        SideMenuController.preferences.animation.initialSpringVelocity = 0.8
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        SideMenuController.preferences.basic.hideMenuWhenEnteringBackground = true
        SideMenuController.preferences.animation.shadowAlpha = 0.5
        SideMenuController.preferences.animation.shadowColor = .black
    }
    
    @IBAction func sideMenuTapped(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func qrTapped(_ sender: UIButton) {
        let scanner = QRCodeScanner()
        scanner.didFoundQRCode = { code in
            print("@@@ QRCode \(code)")
            self.viewModel.assetByQR = nil
            self.viewModel.fetchAssetByBarcode(code: code)
        }
        scanner.didTapCancel = {
            self.searchFlag = .filters
            self.itemsTV.reloadData()
        }
        scanner.modalPresentationStyle = .fullScreen
        self.present(scanner, animated: true)
    }
    
}

extension AssetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFlag == .filters {
            return assetsList.count
        } else {
            return viewModel.assetByQR == nil ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetsTVCell.identifier, for: indexPath) as! AssetsTVCell
        if searchFlag == .filters {
            let asset = assetsList[indexPath.row]
            cell.configure(assetModel: asset)
            cell.assetsId = asset.id
        } else {
            cell.configure(assetByIDModel: viewModel.assetByQR)
            cell.assetsId = viewModel.assetByQR?.id
        }
        cell.delegate = self
        if indexPath.row == assetsList.count - 1, assetsList.count < viewModel.totalAssets, !viewModel.isPaginating {
            viewModel.fetchAssets(filters: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.viewModel.assetByQR == nil {
            if let assetID = assetsList[indexPath.row].id {
                let assetDetailsVC = AssetsDetailsViewController.instantiateِAssetDetails(assetID: assetID)
                navigationController?.pushViewController(assetDetailsVC, animated: true)
            }
        } else {
            if let assetID = self.viewModel.assetByQR?.id {
                let assetDetailsVC = AssetsDetailsViewController.instantiateِAssetDetails(assetID: assetID)
                navigationController?.pushViewController(assetDetailsVC, animated: true)
            }
        }
    }
    
    
    
}


extension AssetsViewController: AssetsTVCell_Delegate {
    func deleteAssets_didSelect(AssetsId: Int) {
        self.confirmationAlert("Confirmation", andLocalizedMessage: "The Asset will be deleted. Do you agree ?",
                               OkBtnLocalizedTitle: "Yes", CancelBtnLocalizedTitle: "No") {
                                (result) in
                                if result {
                                    self.viewModel.deleteAsset(assetID: AssetsId)
                                    }
        }
    }
    
    
}


//self.confirmationAlert(
//    "Error".localized , andLocalizedMessage: errorMessage,
//                                       OkBtnLocalizedTitle: "Close".localized) {
//                                        (result) in
//                                        if result {
//                                            self.requestNotSuccess()
//                                        }
//                }
