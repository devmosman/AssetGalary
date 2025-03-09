//
//  AssetsDetailsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import UIKit

class AssetsDetailsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didLoadAssetImages: (([ImageModel]) -> ())?
    var didGenerateQRCode: ((UIImage) -> ())?
    var didFetchAsset: ((AssetByIDModel) -> ())?
    var didFetchAssetActivity: (([AssetActivityModelElement]) -> ())?
    
    
    func fetchAsset(assetID: Int) {
        didChangeLoading?(true)
        client.request(api: .fetchAssetByID(assetID: assetID), modelType: AssetByIDModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let assetModel):
                self?.didFetchAsset?(assetModel)
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
    
    func generateQRCode(code: String) {
        didChangeLoading?(true)
        client.request(api: .generateQRAsset(code: code), modelType: String.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let QRCode):
                let image = QRCode.imageFromBase64String()
                print("@@@ \(image)")
                self?.didGenerateQRCode?(image)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func getAssetActiviy(assetID: Int) {
        didChangeLoading?(true)
        client.request(api: .getAssetActivity(assetID: assetID), modelType: AssetActivityModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let assetActivityModel):
                self?.didFetchAssetActivity?(assetActivityModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    
}
