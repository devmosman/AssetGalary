//
//  DashboardViewController.swift
//  Asset Manager
//
//  Created by Marwan on 30/07/2022.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var itemsTV: UITableView!
    
    @IBOutlet weak var categoryBgView: UIView!
    @IBOutlet weak var assetBgView: UIView!
    @IBOutlet weak var locationBgView: UIView!
    @IBOutlet weak var assetCountLabel: UILabel!
    @IBOutlet weak var locationCountLabel: UILabel!
    @IBOutlet weak var categoryCountLabel: UILabel!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var allAssetsButton: UIButton!
    @IBOutlet weak var byCategoryButton: UIButton!
    @IBOutlet weak var byLocationButton: UIButton!
    @IBOutlet weak var byCostButton: UIButton!
    
    let viewModel = DashboardViewModel()
    private var dataSource: [Int: [AssetDashboard]] = [:] { didSet { itemsTV.reloadData() } }
    private var sectionNames: [String] = ["Assets By Category", "Assets By Location", "Assets By Cost"]
    private var dashboardModel: DashboardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        setupTableView()
        bind()
        [categoryBgView, assetBgView, locationBgView, buttonsStackView].forEach{
            $0?.alpha = 0
        }
        viewModel.fetchDashboardData()
    }
    
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchDashboardData = { [weak self] dashboardModel in
            guard let self = self else { return }
            self.dashboardModel = dashboardModel
            [self.categoryBgView, self.assetBgView, self.locationBgView, self.buttonsStackView].forEach{
                $0?.alpha = 1
            }
            self.assetCountLabel.text = "\(dashboardModel.assetCount ?? 0)"
            self.locationCountLabel.text = "\(dashboardModel.locationCount ?? 0)"
            self.categoryCountLabel.text = "\(dashboardModel.categoryCount ?? 0)"
            self.setupAllData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(DashboardTVCell.nib, forCellReuseIdentifier: DashboardTVCell.identifier)
    }
    
    private func setupAllData() {
        guard let dashboardModel = dashboardModel else { return }
        sectionNames = ["Assets By Category", "Assets By Location", "Assets By Cost"]
        dataSource = [:]
        dataSource[0] = dashboardModel.assetCountByCategory ?? []
        dataSource[1] = dashboardModel.assetCountByLocation ?? []
        dataSource[2] = dashboardModel.assetPriceByCurrency ?? []
    }
    
    @IBAction func allAssetsTapped(_ sender: UIButton) {
        setupAllData()
        allAssetsButton.backgroundColor = .systemBlue
        [byCategoryButton, byLocationButton, byCostButton].forEach {
            $0?.backgroundColor = .lightGray
        }
    }
    
    @IBAction func byCategoryTapped(_ sender: UIButton) {
        guard let dashboardModel = dashboardModel else { return }
        sectionNames = ["Assets By Category"]
        dataSource = [:]
        dataSource[0] = dashboardModel.assetCountByCategory ?? []
        byCategoryButton.backgroundColor = .systemBlue
        [allAssetsButton, byLocationButton, byCostButton].forEach {
            $0?.backgroundColor = .lightGray
        }
    }
    
    @IBAction func byLocationTapped(_ sender: UIButton) {
        guard let dashboardModel = dashboardModel else { return }
        sectionNames = ["Assets By Location"]
        dataSource = [:]
        dataSource[0] = dashboardModel.assetCountByLocation ?? []
        byLocationButton.backgroundColor = .systemBlue
        [byCategoryButton, allAssetsButton, byCostButton].forEach {
            $0?.backgroundColor = .lightGray
        }
    }
    
    @IBAction func byCostTapped(_ sender: UIButton) {
        guard let dashboardModel = dashboardModel else { return }
        sectionNames = ["Assets By Cost"]
        dataSource = [:]
        dataSource[0] = dashboardModel.assetPriceByCurrency ?? []
        byCostButton.backgroundColor = .systemBlue
        [byCategoryButton, byLocationButton, allAssetsButton].forEach {
            $0?.backgroundColor = .lightGray
        }
    }


}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTVCell.identifier, for: indexPath) as! DashboardTVCell
        let dataSourceArray = Array(dataSource).sorted(by: { $0.key < $1.key })
        cell.sectionTitleLabel.text = sectionNames[indexPath.row]
        cell.setData(assets: dataSourceArray[indexPath.row].value)
        return cell
    }
    
    
}
