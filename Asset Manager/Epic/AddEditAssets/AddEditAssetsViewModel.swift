//
//  AddEditAssetsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import UIKit

class AddEditAssetsViewModel {
    
    private let client = NetworkClient()
    private let dispatchGroup = DispatchGroup()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didLoadLookupData: (() -> ())?
    var didAddUpdateAsset: ((AddUpdateAssetModel) -> ())?
    var didAddImage: (() -> ())?
    var didAddAllImages: (() -> ())?
    var didLoadAssetImages: (([ImageModel]) -> ())?
    var categories = [CategoryModelData]()
    var subCategories = [SubCategoryModelData]()
    var locations = [LocationModelData]()
    var subLocations = [SubLocationModelData]()
    var vendors = [VendorModelData]()
    var units = [UnitModelElement]()
    var currencies = [CurrencyModelElement]()
    
    var didFetchSubCategories: (([SubCategoryModelData]) -> ())?
    var didFetchSubLocations: (([SubLocationModelData]) -> ())?
    
    

    
    func fetchCategories() {
        dispatchGroup.enter()
        didChangeLoading?(true)
        client.request(api: .fetchCategories(filter: "", page: 0, size: 1000), modelType: CategoryModel.self) { [weak self] result in
            switch result {
            case .success(let categoryModel):
                self?.categories = categoryModel.data ?? []
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.didChangeLoading?(false)
            self.didLoadLookupData?()
        }
    }
    
    func fetchSubCategories(id: Int) {
        self.didChangeLoading?(true)
        client.request(api: .fetchSubCategories(filter: "", page: 0, size: 1000, categoryID: "\(id)"), modelType: SubCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let subCategoryModel):
                self?.subCategories = subCategoryModel.data ?? []
                self?.didFetchSubCategories?(subCategoryModel.data ?? [])
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func fetchLocations() {
        dispatchGroup.enter()
        client.request(api: .fetchLocations(filter: "", page: 0, size: 1000), modelType: LocationModel.self) { [weak self] result in
            switch result {
            case .success(let locationModel):
                self?.locations = locationModel.data ?? []
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchSubLocations(id: Int) {
        self.didChangeLoading?(true)
        client.request(api: .fetchSubLocations(filter: "", page: 0, size: 1000, locationID: "\(id)"), modelType: SubLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let subLocationsModel):
                self?.subLocations = subLocationsModel.data ?? []
                self?.didFetchSubLocations?(subLocationsModel.data ?? [])
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }

    
    
    func fetchVendors() {
        dispatchGroup.enter()
        client.request(api: .fetchVendors(filter: "", page: 0, size: 1000), modelType: VendorModel.self) { [weak self] result in
            switch result {
            case .success(let vendorModel):
                self?.vendors = vendorModel.data ?? []
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func addAsset(asset: AddAssetUIModel) {
        didChangeLoading?(true)
        client.request(api: .addAsset(assetUIModel: asset), modelType: AddUpdateAssetModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateAssetModel):
                self?.didAddUpdateAsset?(addUpdateAssetModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateAsset(asset: UpdateAssetUIModel) {
        didChangeLoading?(true)
        client.request(api: .updateAsset(assetUIModel: asset), modelType: AddUpdateAssetModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateAssetModel):
                self?.didAddUpdateAsset?(addUpdateAssetModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func getAssetsImage(assetID: Int) {
        didChangeLoading?(true)
        client.request(api: .getAssetImages(assetID: assetID), modelType: AssetImagesModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let assetImagesModel):
                self?.didLoadAssetImages?(assetImagesModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func addAssetImage(assetID: Int, image: UIImage, name: String) {
        didChangeLoading?(true)
        let base64Image = image.convertImageToBase64EncodedString()
        client.request(api: .addAssetImage(assetID: assetID, base64Image: base64Image, name: name), modelType: Int.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(_):
                self?.didAddImage?()
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func addAssetImages(assetID: Int, images: [String:UIImage]) {
        didChangeLoading?(true)
        for (index,image) in images.enumerated() {
            let base64Image = image.value.convertImageToBase64EncodedString()
            let name = image.key
            client.request(api: .addAssetImage(assetID: assetID, base64Image: base64Image, name: name), modelType: Int.self) { [weak self] result in
                switch result {
                case .success(_):
                    if index == images.count - 1 {
                        self?.didChangeLoading?(false)
                        self?.didAddAllImages?()
                    }
                case .failure(let error):
                    self?.didChangeLoading?(false)
                    self?.didReceiveError?(error.desc)
                }
                
            }
        }
        
    }
    
    func fetchUnits() {
        dispatchGroup.enter()
        client.request(api: .getAssetUnits, modelType: UnitModel.self) { [weak self] result in
            switch result {
            case .success(let unitModel):
                self?.units = unitModel
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchCurrencies() {
        dispatchGroup.enter()
        client.request(api: .getAssetCurrency, modelType: CurrencyModel.self) { [weak self] result in
            switch result {
            case .success(let currencyModel):
                self?.currencies = currencyModel
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    
    
    
    
}
