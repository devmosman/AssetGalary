//
//  AssetsDetailsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 14/06/2022.
//

import UIKit
import FittedSheets

class AssetsDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imagesCV: UICollectionView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var galleryDescriptionLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var serialNoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var purhaseDateLabel: UILabel!
    @IBOutlet weak var warrantyStartLabel: UILabel!
    @IBOutlet weak var warrantyEndLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subLocationLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    private lazy var opacityView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var qrImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var printButton: UIButton = {
        let button = UIButton()
        button.setTitle("Print", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.addTarget(self, action: #selector(printTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelPrintButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.addTarget(self, action: #selector(cancelPrintTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var asset: AssetByIDModel?
    private var assetID: Int!
    var imageList: [ImageModel] = [] {
        didSet {
            imagesCV.reloadData()
        }
    }
    private var qrImage: UIImage?
    
    static func instantiateِAssetDetails(assetID: Int) -> AssetsDetailsViewController {
        let vc = AssetsDetailsViewController()
        vc.assetID = assetID
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Asset Details"
        setupCollectionView()
        setupUI()
        bind()
        viewModel.fetchAsset(assetID: assetID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    let viewModel = AssetsDetailsViewModel()
    func bind() {
        
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didFetchAsset = { [weak self] asset in
            guard let self = self else { return }
            self.setupData(fetchedAsset: asset)
            self.viewModel.getAssetsImage(assetID: self.assetID)
            
        }
        
        viewModel.didLoadAssetImages = { [weak self] images in
            self?.imageList = images
        }
        
        viewModel.didGenerateQRCode = { [weak self] image in
            self?.qrImage = image
            self?.qrImageView.image = image
            UIView.animate(withDuration: 0.3) {
                self?.opacityView.alpha = 1
            }
        }
        
        viewModel.didFetchAssetActivity = { [weak self] assetActivity in
            let assetActivityVC = AssetActivityViewController()
            assetActivityVC.activityList = assetActivity
            let sheetOptions = SheetOptions(pullBarHeight: 10, presentingViewCornerRadius: 20, shouldExtendBackground: true, setIntrinsicHeightOnNavigationControllers: nil, useFullScreenMode: false, shrinkPresentingViewController: true, useInlineMode: false, horizontalPadding: 0, maxWidth: nil)
            let sheetVC = SheetViewController(controller: assetActivityVC, sizes: [.percent(0.85)], options: sheetOptions)
            sheetVC.gripColor = .clear
            sheetVC.cornerRadius = 20
            sheetVC.pullBarBackgroundColor = UIColor.clear
            sheetVC.dismissOnPull = true
            sheetVC.dismissOnOverlayTap = true
            self?.present(sheetVC, animated: true)
        }
    }
    
    private func setupUI() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton

        view.addSubview(opacityView)
        opacityView.addSubview(qrImageView)
        opacityView.addSubview(printButton)
        opacityView.addSubview(cancelPrintButton)
        
        NSLayoutConstraint.activate([
            opacityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            opacityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            opacityView.topAnchor.constraint(equalTo: view.topAnchor),
            opacityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            qrImageView.centerXAnchor.constraint(equalTo: opacityView.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: opacityView.centerYAnchor, constant: -UIScreen.main.bounds.width * 0.25),
            qrImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85),
            qrImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            printButton.centerXAnchor.constraint(equalTo: opacityView.centerXAnchor),
            printButton.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
            printButton.heightAnchor.constraint(equalToConstant: 50),
            printButton.widthAnchor.constraint(equalToConstant: 150),
            
            cancelPrintButton.centerXAnchor.constraint(equalTo: opacityView.centerXAnchor),
            cancelPrintButton.topAnchor.constraint(equalTo: printButton.bottomAnchor, constant: 20),
            cancelPrintButton.heightAnchor.constraint(equalToConstant: 50),
            cancelPrintButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupData(fetchedAsset: AssetByIDModel) {
        nameLabel.text = fetchedAsset.discription
        codeLabel.text = fetchedAsset.code
        modelNameLabel.text = fetchedAsset.model
        galleryDescriptionLabel.text = fetchedAsset.galleryDescription
        serialNoLabel.text = fetchedAsset.serialNumber
        priceLabel.text = "\(fetchedAsset.price ?? 0)" + " " + (fetchedAsset.currencyDesc ?? "")
        quantityLabel.text = "\(fetchedAsset.quantity ?? 0)"
        widthLabel.text = (fetchedAsset.width ?? "") + " " + (fetchedAsset.wUnitDesc ?? "")
        heightLabel.text = (fetchedAsset.hight ?? "") + " " + (fetchedAsset.hUnitDesc ?? "")
        purhaseDateLabel.text = fetchedAsset.purchaseDate
        warrantyStartLabel.text = fetchedAsset.warrantyStartDate
        warrantyEndLabel.text = fetchedAsset.warrantyEndDate
        notesLabel.text = fetchedAsset.notes
        statusLabel.text = fetchedAsset.status == 0 ? "out of stock" : "in stock"
        categoryLabel.text = (fetchedAsset.categoryNameEn ?? "") + " - " + (fetchedAsset.categoryNameAr ?? "")
        subCategoryLabel.text = (fetchedAsset.subCategoryNameEn ?? "") + " - " + (fetchedAsset.subCategoryNameAr ?? "")
        locationLabel.text = (fetchedAsset.locationNameEn ?? "") + " - " + (fetchedAsset.locationNameAr ?? "")
        subLocationLabel.text = (fetchedAsset.subLocationEn ?? "") + " - " + (fetchedAsset.subLocationNameAr ?? "")
        vendorLabel.text = (fetchedAsset.vendorNameEn ?? "") + " - " + (fetchedAsset.vendorNameAr ?? "")
        
        asset = fetchedAsset
    }
    
    @objc func editButtonTapped() {
        if let asset = asset {
            
            let editAssetVC = AddEditAssetsViewController.instantiateEditUser(asset: asset)
            let navController = UINavigationController(rootViewController: editAssetVC)
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.tintColor = .black
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
            ]
            navController.modalPresentationStyle = .fullScreen
            editAssetVC.delegate = self
            present(navController, animated: true)
        }
        
    }
    
    @objc func printTapped() {
        UIView.animate(withDuration: 0.3) {
            self.opacityView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let info = UIPrintInfo(dictionary:nil)
            info.outputType = UIPrintInfo.OutputType.general
            info.jobName = "Printing QR Code"
            let vc = UIPrintInteractionController.shared
            vc.printInfo = info
            vc.printingItem = self.qrImage
            vc.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
        }
        
    }
    
    @objc func cancelPrintTapped() {
        UIView.animate(withDuration: 0.3) {
            self.opacityView.alpha = 0
        }
    }
    
    func setupCollectionView() {
        imagesCV.delegate = self
        imagesCV.dataSource = self
        imagesCV.register(ImageCVCell.nib, forCellWithReuseIdentifier: ImageCVCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 140, height: 140)
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        imagesCV.setCollectionViewLayout(layout, animated: true)
    }
    
    
    @IBAction func generateQRCodeTapped(_ sender: UIButton) {
        guard let code = asset?.code else {
            showAlert(message: "This asset has no code to generate")
            return
        }
        viewModel.generateQRCode(code: code)
    }
    
    
    @IBAction func assetActivityTapped(_ sender: UIButton) {
        viewModel.getAssetActiviy(assetID: assetID)
    }
    


}

extension AssetsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier, for: indexPath) as! ImageCVCell
        cell.deleteView.alpha = 0
        cell.assetImageView.image = imageList[indexPath.row].fileData.imageFromBase64String()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageList[indexPath.row].fileData.imageFromBase64String()
        let photoDetailsVC = PhotoDetailsViewController()
        photoDetailsVC.images = imageList.map { $0.fileData.imageFromBase64String() }
        photoDetailsVC.selectedIndex = indexPath.row
        navigationController?.pushViewController(photoDetailsVC, animated: true)
    }
    
    
}

extension AssetsDetailsViewController: AddEditAssetDelegate {
    
    func didSave() {
        viewModel.fetchAsset(assetID: assetID)
    }
}
