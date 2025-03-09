//
//  AssetsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

class AssetsViewModel {
    
    let client = NetworkClient()
    private let dispatchGroup = DispatchGroup()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchAssets: (([AssetModelData], Bool) -> ())?
    var didFetchAssetByQR: (() -> ())?
    var didDeleteSuccess: ((Bool) -> ())?
    var assetByQR: AssetByIDModel?
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalAssets = 0
    
    var didLoadLookupData: (() -> ())?
    var categories = [CategoryModelData]()
    var locations = [LocationModelData]()
    var vendors = [VendorModelData]()
    func fetchAssets(filters: [String: Any], paging: Bool = false) {
        
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting Assets with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filters["name"] as? String ?? ""
        let categoryID = filters["categoryID"] as? String ?? ""
        let subCategoryID = filters["subCategoryID"] as? String ?? ""
        let locationID = filters["locationID"] as? String ?? ""
        let subLocationID = filters["subLocationID"] as? String ?? ""
        let vendorID = filters["vendorID"] as? String ?? ""
        client.request(api: .fetchAssets(filter: name, page: page, size: 5, locID: locationID, subLocID: subLocationID, catID: categoryID, subCatID: subCategoryID, vendID: vendorID), modelType: AssetModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let assetModel):
                self?.totalAssets = assetModel.totalRowCount ?? 0
                self?.didFetchAssets?(assetModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
    
    
    func fetchAssetByBarcode(code: String) {
        didChangeLoading?(true)
        client.request(api: .fetchAssetByBarcode(code: code), modelType: AssetByIDModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let assetModel):
                self?.assetByQR = assetModel
                self?.didFetchAssetByQR?()
            case .failure(let error):
                switch error {
                case .notFound:
                    self?.didFetchAssetByQR?()
                default:
                    self?.didReceiveError?(error.desc)
                }
                
            }
        }
    }
    
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
    
    func deleteAsset(assetID: Int) {
        didChangeLoading?(true)
        client.request(api: .deleteAssetByID(assetID: assetID), modelType: Int.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let isSuccess):
                if isSuccess == 1  {
                    self?.didDeleteSuccess?(true)
                }
                self?.didDeleteSuccess?(false)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
