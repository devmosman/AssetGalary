//
//  AddEditAssetsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 16/06/2022.
//

import UIKit

protocol AddEditAssetDelegate {
    func didSave()
}


class AddEditAssetsViewController: BaseViewController {
    

    private var state: AddEditState = .add
    private var asset: AssetByIDModel?
    var selectedCategoryID: Int?
    var selectedSubCategoryID: Int?
    var selectedLocationID: Int?
    var selectedSubLocationID: Int?
    var selectedVendorID: Int?
    var selectedCurrencyID: Int?
    var selectedWidthUnitID: Int?
    var selectedHeightUnitID: Int?
    var purchaseDate: String?
    var warrantyStartDate: String?
    var warrantyEndDate: String?
    var images: [String: UIImage] = [:] {
        didSet {
            itemsCV.reloadData()
        }
    }
    
    var delegate: AddEditAssetDelegate?
    
    @IBOutlet weak var modelNameViewWidth: NSLayoutConstraint!
    @IBOutlet weak var codeStaticLabel: UILabel!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var modelNameView: UIView!
    @IBOutlet weak var serialNumberView: UIView!
    @IBOutlet weak var galleryDescriptionView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var widthView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var purchaseDateView: UIView!
    @IBOutlet weak var warrantyStartView: UIView!
    @IBOutlet weak var warrantyEndView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var subLocationView: UIView!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var widthScaleView: UIView!
    @IBOutlet weak var heightScaleView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var modelNameTF: UITextField!
    @IBOutlet weak var galleryDescriptionTF: UITextField!
    
    @IBOutlet weak var serialNumberTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var widthTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var purchaseDateTF: UITextField!
    @IBOutlet weak var warrantyStartDateTF: UITextField!
    @IBOutlet weak var warrantyEndDateTF: UITextField!
    
    @IBOutlet weak var notesTF: UITextView!
   
    
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sublocationLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var widthUnitLabel: UILabel!
    @IBOutlet weak var heightUnitLabel: UILabel!
    
    @IBOutlet weak var itemsCV: UICollectionView!
    
    @IBOutlet weak var itemsCVHeight: NSLayoutConstraint!
    @IBOutlet weak var imagesStaticLabel: UILabel!
    
    @IBOutlet weak var addImageView: UIView!
    
    @IBOutlet weak var isActiveButton: UIButton!
    
    private let purchaseDatePicker = UIDatePicker()
    private let warrantyStartDatePicker = UIDatePicker()
    private let warrantyEndDatePicker = UIDatePicker()
    
    var imageList: [ImageModel] = [] {
        didSet {
            itemsCV.reloadData()
        }
    }
    
    var firstTimeLoadSubCategories = true
    var firstTimeLoadSubLocations = true
    
    var isActive = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDatePickers()
        setupCollectionView()
        bind()
        viewModel.fetchCategories()
        viewModel.fetchLocations()
        viewModel.fetchVendors()
        viewModel.fetchUnits()
        viewModel.fetchCurrencies()
        
        if state == .edit, let assetID = asset?.id { viewModel.getAssetsImage(assetID: assetID) }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }


    static func instantiateAddUser() -> AddEditAssetsViewController {
        let vc = AddEditAssetsViewController()
        return vc
    }
    
    static func instantiateEditUser(asset: AssetByIDModel) -> AddEditAssetsViewController {
        let vc = AddEditAssetsViewController()
        vc.state = .edit
        vc.asset = asset
        return vc
    }
    
    let viewModel = AddEditAssetsViewModel()
    func bind() {
        viewModel.didChangeLoading = { [weak self] loading in
            self?.startLoading(loading)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.didLoadLookupData = { [weak self] in
            self?.setupData()
            if self?.state == .edit, let assetID = self?.asset?.id { self?.viewModel.getAssetsImage(assetID: assetID) }
        }
        
        viewModel.didAddUpdateAsset = { [weak self] asset in
            guard let self = self, let assetID = asset.id else { return }
            if self.state == .edit {
                self.delegate?.didSave()
                self.dismiss(animated: true)
            } else {
                if self.images.isEmpty {
                    self.delegate?.didSave()
                    self.dismiss(animated: true)
                } else {
                    self.viewModel.addAssetImages(assetID: assetID, images: self.images)
                }
            }
            
        }
        
        viewModel.didAddImage = { [weak self] in
            if let assetID = self?.asset?.id {
                self?.viewModel.getAssetsImage(assetID: assetID)
            }
        }
        
        viewModel.didAddAllImages = { [weak self] in
            self?.delegate?.didSave()
            self?.dismiss(animated: true)
        }
        
        viewModel.didLoadAssetImages = { [weak self] images in
            self?.imageList = images
        }
        
        viewModel.didFetchSubCategories = { [weak self] subCategories in
            guard let self = self else { return }
            self.subCategoryLabel.textColor = .lightGray
            self.subCategoryLabel.text = "sub-category"
            self.selectedSubCategoryID = nil
            
            if self.state == .edit, self.firstTimeLoadSubCategories, let asset = self.asset {
                self.subCategoryLabel.textColor = .black
                self.subCategoryLabel.text = (subCategories.first(where: { $0.id == asset.subCategoryID })?.nameEn ?? "") + " - " + (subCategories.first(where: { $0.id == asset.subCategoryID })?.nameAr ?? "")
                self.selectedSubCategoryID = asset.subCategoryID
                self.firstTimeLoadSubCategories = false
            }
        }
        
        viewModel.didFetchSubLocations = { [weak self] subLocations in
            guard let self = self else { return }
            self.sublocationLabel.textColor = .lightGray
            self.sublocationLabel.text = "sub-location"
            self.selectedSubLocationID = nil
            
            if self.state == .edit, self.firstTimeLoadSubLocations, let asset = self.asset {
                self.sublocationLabel.textColor = .black
                self.sublocationLabel.text = (subLocations.first(where: { $0.id == asset.subLocationID })?.nameEn ?? "") + " - " + (subLocations.first(where: { $0.id == asset.subLocationID })?.nameAr ?? "")
                self.selectedSubLocationID = asset.subLocationID
                self.firstTimeLoadSubLocations = false
            }
        }
        
        

    }
    
    private func setupUI() {
        titleLabel.text = state == .edit ? "Edit Asset" : "Add New Asset"
        
        [codeView, modelNameView,galleryDescriptionView, serialNumberView, priceView, quantityView, widthView, heightView, purchaseDateView, warrantyEndView, warrantyStartView, notesView, categoryView, subCategoryView, locationView, subLocationView, vendorView, currencyView, widthScaleView, heightScaleView].forEach {
            $0!.makeShadowsAndCorners(cornerRadius: 7)
            $0!.makeBorders(borderWidth: 1, borderColor: .black.withAlphaComponent(0.4))
        }
        
        if state == .add {
            imagesStaticLabel.text = ""
            codeView.alpha = 0
            codeStaticLabel.alpha = 0
            modelNameViewWidth.isActive = false
            modelNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
            codeTF.isEnabled = false
        }
        
        if state == .edit {
            codeTF.isEnabled = false
            codeView.backgroundColor = .black.withAlphaComponent(0.1)
        }
        
        categoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryPicker)))
        subCategoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSubCategoryPicker)))
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLocationPicker)))
        subLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSubLocationPicker)))
        vendorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openVendorPicker)))
        currencyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCurrencyPicker)))
        heightScaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openHeightPicker)))
        widthScaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openWidthPicker)))
        
    }
    
    func setupCollectionView() {
        itemsCV.delegate = self
        itemsCV.dataSource = self
        itemsCV.register(ImageCVCell.nib, forCellWithReuseIdentifier: ImageCVCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 140, height: 140)
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        itemsCV.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupDatePickers() {
        purchaseDatePicker.datePickerMode = .date
        warrantyStartDatePicker.datePickerMode = .date
        warrantyEndDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            purchaseDatePicker.preferredDatePickerStyle = .wheels
            warrantyStartDatePicker.preferredDatePickerStyle = .wheels
            warrantyEndDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        
        let done1Button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePurchaseDate))
        let done2Button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWarrantyStart))
        let done3Button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWarrantyEnd))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar1.setItems([done1Button,spaceButton,cancelButton], animated: false)
        toolbar2.setItems([done2Button,spaceButton,cancelButton], animated: false)
        toolbar3.setItems([done3Button,spaceButton,cancelButton], animated: false)
        
        purchaseDateTF.inputAccessoryView = toolbar1
        warrantyStartDateTF.inputAccessoryView = toolbar2
        warrantyEndDateTF.inputAccessoryView = toolbar3
        purchaseDateTF.inputView = purchaseDatePicker
        warrantyStartDateTF.inputView = warrantyStartDatePicker
        warrantyEndDateTF.inputView = warrantyEndDatePicker
        
    }

    @objc func donePurchaseDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        purchaseDateTF.text = formatter.string(from: purchaseDatePicker.date)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        purchaseDate = formatter.string(from: purchaseDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneWarrantyStart() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        warrantyStartDateTF.text = formatter.string(from: warrantyStartDatePicker.date)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        warrantyStartDate = formatter.string(from: warrantyStartDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneWarrantyEnd() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        warrantyEndDateTF.text = formatter.string(from: warrantyEndDatePicker.date)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        warrantyEndDate = formatter.string(from: warrantyEndDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func openCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.categories.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.categoryLabel.text = value
            self?.categoryLabel.textColor = .black
            self?.selectedCategoryID = id
            self?.viewModel.fetchSubCategories(id: id)
        }
        picker.show(vc: self, array: array, selectedID: selectedCategoryID, title: "Categories")
    }
    @objc func openSubCategoryPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.subCategories.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.subCategoryLabel.textColor = .black
            self?.subCategoryLabel.text = value
            self?.selectedSubCategoryID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedSubCategoryID, title: "Sub-Categories")
    }
    @objc func openLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.locations.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.locationLabel.text = value
            self?.locationLabel.textColor = .black
            self?.selectedLocationID = id
            self?.viewModel.fetchSubLocations(id: id)
        }
        picker.show(vc: self, array: array, selectedID: selectedLocationID, title: "Locations")
    }
    @objc func openSubLocationPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.subLocations.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.sublocationLabel.textColor = .black
            self?.sublocationLabel.text = value
            self?.selectedSubLocationID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedSubLocationID, title: "Sub-Locations")
    }
    @objc func openVendorPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.vendors.map { PickerModel(name: ($0.nameEn ?? "") + " - " + ($0.nameAr ?? ""), id: $0.id ?? 0) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.vendorLabel.text = value
            self?.vendorLabel.textColor = .black
            self?.selectedVendorID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedVendorID, title: "Vendors")
    }
    @objc func openCurrencyPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.currencies.map { PickerModel(name: $0.name, id: $0.id) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.currencyLabel.text = value
            self?.currencyLabel.textColor = .black
            self?.selectedCurrencyID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedCurrencyID, title: "Currencies")
    }
    @objc func openHeightPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.units.map { PickerModel(name: $0.name, id: $0.id) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.heightUnitLabel.text = value
            self?.heightUnitLabel.textColor = .black
            self?.selectedHeightUnitID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedHeightUnitID, title: "Units")
    }
    @objc func openWidthPicker() {
        let picker = CustomPicker()
        let array: [PickerModel] = viewModel.units.map { PickerModel(name: $0.name, id: $0.id) }
        picker.didPickValue = { [weak self] (id, value) in
            guard id != 0 else { return }
            print("### Selected String: \(value)")
            print("### Selected id: \(id)")
            self?.widthUnitLabel.text = value
            self?.widthUnitLabel.textColor = .black
            self?.selectedWidthUnitID = id
        }
        picker.show(vc: self, array: array, selectedID: selectedWidthUnitID, title: "Units")
    }
    
    func setupData() {

        currencyLabel.textColor = .black
        currencyLabel.text = viewModel.currencies.first(where: { $0.isDefault })?.name
        selectedCurrencyID = viewModel.currencies.first(where: { $0.isDefault })?.id
        
        widthUnitLabel.textColor = .black
        widthUnitLabel.text = viewModel.units.first(where: { $0.isDefault })?.name
        selectedWidthUnitID = viewModel.units.first(where: { $0.isDefault })?.id
        
        heightUnitLabel.textColor = .black
        heightUnitLabel.text = viewModel.units.first(where: { $0.isDefault })?.name
        selectedHeightUnitID = viewModel.units.first(where: { $0.isDefault })?.id
        
        
        
        if state == .edit, let asset = asset {
            selectedCategoryID = asset.categoryID
            categoryLabel.textColor = .black
            categoryLabel.text = (viewModel.categories.first(where: { $0.id == asset.categoryID })?.nameEn ?? "") + " - " + (viewModel.categories.first(where: { $0.id == asset.categoryID })?.nameAr ?? "")
            
            selectedLocationID = asset.locationID
            locationLabel.textColor = .black
            locationLabel.text = (viewModel.locations.first(where: { $0.id == asset.locationID })?.nameEn ?? "") + " - " + (viewModel.locations.first(where: { $0.id == asset.locationID })?.nameAr ?? "")
            
            selectedVendorID = asset.vendorID
            vendorLabel.textColor = .black
            vendorLabel.text = (viewModel.vendors.first(where: { $0.id == asset.vendorID })?.nameEn ?? "") + " - " + (viewModel.vendors.first(where: { $0.id == asset.vendorID })?.nameAr ?? "")
            
            if let stringCurrency = asset.priceCurrencyId, let assetCurrencyID = Int(stringCurrency) {
                currencyLabel.textColor = .black
                currencyLabel.text = viewModel.currencies.first(where: { $0.id == assetCurrencyID })?.name
                selectedCurrencyID = assetCurrencyID
            }
            
            if let stringWidthUnit = asset.wUnitId, let assetWidthUnitID = Int(stringWidthUnit) {
                widthUnitLabel.textColor = .black
                widthUnitLabel.text = viewModel.units.first(where: { $0.id == assetWidthUnitID })?.name
                selectedWidthUnitID = assetWidthUnitID
            }
            
            if let stringHeightUnit = asset.hUnitId, let assetHeightUnitID = Int(stringHeightUnit) {
                heightUnitLabel.textColor = .black
                heightUnitLabel.text = viewModel.units.first(where: { $0.id == assetHeightUnitID })?.name
                selectedHeightUnitID = assetHeightUnitID
            }
            
            if let categoryID = asset.categoryID {
                viewModel.fetchSubCategories(id: categoryID)
            }
            
            if let locationID = asset.locationID {
                viewModel.fetchSubLocations(id: locationID)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MMM d, yyyy"
            codeTF.text = asset.code
            modelNameTF.text = asset.model
            galleryDescriptionTF.text = asset.galleryDescription
            serialNumberTF.text = asset.serialNumber
            priceTF.text = "\(asset.price ?? 0)"
            quantityTF.text = "\(asset.quantity ?? 0)"
            widthTF.text = asset.width
            heightTF.text = asset.hight
            if let purchaseDate = asset.purchaseDate, let date = dateFormatter.date(from: purchaseDate) {
                purchaseDateTF.text = dateFormatter1.string(from: date)
                purchaseDatePicker.date = date
            }
            if let warrantyStartDate = asset.warrantyStartDate, let date = dateFormatter.date(from: warrantyStartDate) {
                warrantyStartDateTF.text = dateFormatter1.string(from: date)
                warrantyStartDatePicker.date = date
            }
            if let warrantyEndDate = asset.warrantyEndDate, let date = dateFormatter.date(from: warrantyEndDate) {
                warrantyEndDateTF.text = dateFormatter1.string(from: date)
                warrantyEndDatePicker.date = date
            }
            
            notesTF.text = asset.notes
            isActive = asset.status ?? 0
            isActiveButton.isSelected = asset.status == 1 ? true : false
            
//            selectedSubCategoryID = asset.subCategoryID
//            selectedSubLocationID = asset.subLocationID
            purchaseDate = asset.purchaseDate
            warrantyStartDate = asset.warrantyStartDate
            warrantyEndDate = asset.warrantyEndDate
        }
        
        
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        if state == .edit {
            ImageManager.shared.showActionSheet(vc: self)
            ImageManager.shared.imagePickedBlock = { [weak self] info in
                let image = ImageManager.shared.getImage(info: info)
                let name = "\((self?.imageList.count ?? 0) + 1).png"
                if let assetID = self?.asset?.id {
                    self?.viewModel.addAssetImage(assetID: assetID, image: image, name: name)
                }
                
            }
        } else {
            ImageManager.shared.showActionSheet(vc: self)
            ImageManager.shared.imagePickedBlock = { [weak self] info in
                let image = ImageManager.shared.getImage(info: info)
                let name = "\((self?.images.count ?? 0) + 1).png"
                self?.images[name] = image
            }
        }
        
    }
    
    @IBAction func activeBtnTapped(_ seneder: UIButton){
        if isActiveButton.isSelected {
            isActive = 0
        } else {
            isActive = 1
        }
        isActiveButton.isSelected.toggle()
    }
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if state == .add {
            addAsset()
        } else {
            updateAsset()
        }
    }
    
    private func addAsset() {
        guard let modelName = modelNameTF.text,let galleryDescription = galleryDescriptionTF.text, let categoryID = selectedCategoryID,
              let subCategoryID = selectedSubCategoryID, let locationID = selectedLocationID,
              let subLocationID = selectedSubLocationID else {
            showAlert(message: "Please Fill in all fields")
            return }
        
        let currencyID = selectedCurrencyID
        let heightUnitID = selectedHeightUnitID
        let widthUnitID = selectedWidthUnitID
        let serialNo = serialNumberTF.text
        let price = priceTF.text
        let width = widthTF.text
        let height = heightTF.text
        let warrantyStart = warrantyStartDate
        let warrantyEnd = warrantyEndDate
        let quantity = quantityTF.text
        let purchaseDate = purchaseDate
        let notes = notesTF.text
        let categoryEN = viewModel.categories.first(where: {$0.id == categoryID})?.nameEn
        let categoryAR = viewModel.categories.first(where: {$0.id == categoryID})?.nameAr
        let subCategoryEN = viewModel.subCategories.first(where: {$0.id == subCategoryID})?.nameEn
        let subCategoryAR = viewModel.subCategories.first(where: {$0.id == subCategoryID})?.nameAr
        let locationEN = viewModel.locations.first(where: {$0.id == locationID})?.nameEn
        let locationAR = viewModel.locations.first(where: {$0.id == locationID})?.nameAr
        let subLocationEN = viewModel.subLocations.first(where: {$0.id == subLocationID})?.nameEn
        let subLocationAR = viewModel.subLocations.first(where: {$0.id == subLocationID})?.nameAr
        let vendorID = selectedVendorID
        let vendorEN = viewModel.vendors.first(where: {$0.id == vendorID})?.nameEn
        let vendorAR = viewModel.vendors.first(where: {$0.id == vendorID})?.nameAr
        

        let asset = AddAssetUIModel(code: "code",
                                    serialNumber: serialNo ?? "",
                                    discription: modelName,
                                    galleryDescription: galleryDescription,
                                    price: price,
                                    quantity: quantity == nil ? nil : Int(quantity ?? "0"),
                                    model: modelName,
                                    width: width,
                                    hight: height,
                                    purchaseDate: purchaseDate,
                                    warrantyStartDate: warrantyStart,
                                    warrantyEndDate: warrantyEnd,
                                    notes: notes,
                                    status: isActive,
                                    locationId: locationID,
                                    subLocationId: subLocationID,
                                    categoryId: categoryID,
                                    subCategoryId: subCategoryID,
                                    vendorId: vendorID,
                                    locationNameAr: locationAR,
                                    locationNameEn: locationEN,
                                    subLocationNameAr: subLocationAR,
                                    subLocationEn: subLocationEN,
                                    categoryNameAr: categoryAR,
                                    categoryNameEn: categoryEN,
                                    subCategoryNameAr: subCategoryAR,
                                    subCategoryNameEn: subCategoryEN,
                                    vendorNameAr: vendorAR,
                                    vendorNameEn: vendorEN,
                                    priceCurrencyId: currencyID,
                                    wUnitId: widthUnitID,
                                    hUnitId: heightUnitID
        )

        viewModel.addAsset(asset: asset)
    }
    
    private func updateAsset() {
        guard let id = asset?.id,
              let modelName = modelNameTF.text, let galleryDescription = galleryDescriptionTF.text , let categoryID = selectedCategoryID,
              let subCategoryID = selectedSubCategoryID, let locationID = selectedLocationID,
              let subLocationID = selectedSubLocationID else {
            showAlert(message: "Please Fill in all fields")
            return }
        
        let code = codeTF.text
        let currencyID = selectedCurrencyID
        let heightUnitID = selectedHeightUnitID
        let widthUnitID = selectedWidthUnitID
        let serialNo = serialNumberTF.text
        let price = priceTF.text
        let width = widthTF.text
        let height = heightTF.text
        let warrantyStart = warrantyStartDate
        let warrantyEnd = warrantyEndDate
        let quantity = quantityTF.text
        let purchaseDate = purchaseDate
        let notes = notesTF.text
        let vendorID = selectedVendorID
        let categoryEN = viewModel.categories.first(where: {$0.id == categoryID})?.nameEn
        let categoryAR = viewModel.categories.first(where: {$0.id == categoryID})?.nameAr
        let subCategoryEN = viewModel.subCategories.first(where: {$0.id == subCategoryID})?.nameEn
        let subCategoryAR = viewModel.subCategories.first(where: {$0.id == subCategoryID})?.nameAr
        let locationEN = viewModel.locations.first(where: {$0.id == locationID})?.nameEn
        let locationAR = viewModel.locations.first(where: {$0.id == locationID})?.nameAr
        let subLocationEN = viewModel.subLocations.first(where: {$0.id == subLocationID})?.nameEn
        let subLocationAR = viewModel.subLocations.first(where: {$0.id == subLocationID})?.nameAr
        let vendorEN = viewModel.vendors.first(where: {$0.id == vendorID})?.nameEn
        let vendorAR = viewModel.vendors.first(where: {$0.id == vendorID})?.nameAr
        
        let asset = UpdateAssetUIModel(id: id,
                                       code: code,
                                       serialNumber: serialNo,
                                       discription: modelName,
                                       galleryDescription : galleryDescription,
                                       price: price,
                                       quantity: quantity == nil ? nil : Int(quantity ?? "0"),
                                       model: modelName,
                                       width: width,
                                       hight: height,
                                       purchaseDate: purchaseDate,
                                       warrantyStartDate: warrantyStart,
                                       warrantyEndDate: warrantyEnd,
                                       notes: notes,
                                       status: isActive,
                                       locationId: locationID,
                                       subLocationId: subLocationID,
                                       categoryId: categoryID,
                                       subCategoryId: subCategoryID,
                                       vendorId: vendorID,
                                       locationNameAr: locationAR,
                                       locationNameEn: locationEN,
                                       subLocationNameAr: subLocationAR,
                                       subLocationEn: subLocationEN,
                                       categoryNameAr: categoryAR,
                                       categoryNameEn: categoryEN,
                                       subCategoryNameAr: subCategoryAR,
                                       subCategoryNameEn: subCategoryEN,
                                       vendorNameAr: vendorAR,
                                       vendorNameEn: vendorEN,
                                       priceCurrencyId: currencyID,
                                       wUnitId: widthUnitID,
                                       hUnitId: heightUnitID
        )

        viewModel.updateAsset(asset: asset)
    }
    
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }


}

extension AddEditAssetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state == .edit ? imageList.count : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier, for: indexPath) as! ImageCVCell
        cell.assetImageView.image = state == .edit ? imageList[indexPath.row].fileData.imageFromBase64String() : Array(images.values)[indexPath.row]
        cell.deleteView.alpha = 0

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if state == .edit {
            let photoDetailsVC = PhotoDetailsViewController()
            photoDetailsVC.images = imageList.map { $0.fileData.imageFromBase64String() }
            photoDetailsVC.selectedIndex = indexPath.row
            navigationController?.pushViewController(photoDetailsVC, animated: true)
        }
    }
    
    
}
