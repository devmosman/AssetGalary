//
//  SubCategoriesViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class SubCategoriesViewController: BaseViewController {
    
    @IBOutlet weak var itemsTV: UITableView!
    
    private var subCategoriesList = [SubCategoryModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var filters = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sub Categories"
        setupTableView()
        setupUI()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchSubCategories(filter: [:])
    }
    
    let viewModel = SubCategoryViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchSubCategories = { [weak self] (subCategories, isPaging) in
            if isPaging {
                self?.subCategoriesList.append(contentsOf: subCategories)
            } else {
                self?.subCategoriesList = subCategories
            }
        }
        
        viewModel.didFetchCategories = { [weak self] categories in
            self?.openFilterScreen(categories: categories)
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
        viewModel.fetchCategories()
    }
    
    @objc func addButtonTapped() {
        let addSubCategoryVC = AddEditSubCategoriesViewController.instantiateAddUser()
        addSubCategoryVC.modalPresentationStyle = .fullScreen
        present(addSubCategoryVC, animated: true)
    }
    
    func openFilterScreen(categories: [CategoryModelData]) {
        let filtersVC = SubFilterSheetViewController()
        filtersVC.filters = filters
        filtersVC.openedFrom = .subCategory
        filtersVC.categories = categories
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchSubCategories(filter: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchSubCategories(filter: [:])
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

    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 240
        itemsTV.register(SubCategoriesTVCell.nib, forCellReuseIdentifier: SubCategoriesTVCell.identifier)
    }

}

extension SubCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoriesTVCell.identifier, for: indexPath) as! SubCategoriesTVCell
        let subCategory = subCategoriesList[indexPath.row]
        cell.configure(subCategoryModel: subCategory)
        
        if indexPath.row == subCategoriesList.count - 1, subCategoriesList.count < viewModel.totalSubCategories, !viewModel.isPaginating {
            viewModel.fetchSubCategories(filter: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addSubCategoryVC = AddEditSubCategoriesViewController.instantiateEditUser(subCategory: subCategoriesList[indexPath.row])
        addSubCategoryVC.modalPresentationStyle = .fullScreen
        present(addSubCategoryVC, animated: true)
    }
    
}
