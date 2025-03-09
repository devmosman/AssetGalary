//
//  CategoriesViewController.swift
//  Asset Manager
//
//  Created by Marwan on 15/06/2022.
//

import UIKit
import FittedSheets

class CategoriesViewController: BaseViewController {

    @IBOutlet weak var itemsTV: UITableView!
    
    private var categoriesList = [CategoryModelData]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    private var filters = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
        setupTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchCategories(filter: [:])
    }
    
    let viewModel = CategoriesViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchCategories = { [weak self] (categories, isPaging) in
            if isPaging {
                self?.categoriesList.append(contentsOf: categories)
            } else {
                self?.categoriesList = categories
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
        filtersVC.openedFrom = .category
        
        filtersVC.didTapSearchFilter = { filters in
            filtersVC.dismiss(animated: true)
            self.filters = filters
            self.viewModel.fetchCategories(filter: filters)
        }
        
        filtersVC.didTapResetFilter = {
            self.filters = [:]
            self.viewModel.fetchCategories(filter: [:])
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
        let addCategoryVC = AddEditCategoriesViewController.instantiateAddUser()
        addCategoryVC.modalPresentationStyle = .fullScreen
        present(addCategoryVC, animated: true)
    }


    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.rowHeight = 135
        itemsTV.register(CategoriesTVCell.nib, forCellReuseIdentifier: CategoriesTVCell.identifier)
    }

}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTVCell.identifier, for: indexPath) as! CategoriesTVCell
        let category = categoriesList[indexPath.row]
        cell.configure(categoryModel: category)
        
        
        if indexPath.row == categoriesList.count - 1, categoriesList.count < viewModel.totalCategories, !viewModel.isPaginating {
            viewModel.fetchCategories(filter: filters, paging: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addCategoryVC = AddEditCategoriesViewController.instantiateEditUser(category: categoriesList[indexPath.row])
        addCategoryVC.modalPresentationStyle = .fullScreen
        present(addCategoryVC, animated: true)
    }
    
    
    
}
