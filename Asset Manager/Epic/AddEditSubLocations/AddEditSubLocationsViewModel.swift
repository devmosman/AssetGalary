//
//  AddEditSubLocationsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class AddEditSubLocationsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchLocations: (([LocationModelData]) -> ())?
    var didAddUpdateSubLocation: ((AddUpdateSubLocationModel) -> ())?

    
    func fetchLocation() {
        didChangeLoading?(true)
        client.request(api: .fetchLocations(filter: "", page: 0, size: 1000), modelType: LocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let locationModel):
                self?.didFetchLocations?(locationModel.data ?? [])
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func addSubLocation(code: String, nameAR: String, nameEN: String, locationID: Int) {
        didChangeLoading?(true)
        client.request(api: .addSubLocation(code: code, nameAR: nameAR, nameEN: nameEN, locationID: locationID), modelType: AddUpdateSubLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateSubLocationModel):
                self?.didAddUpdateSubLocation?(addUpdateSubLocationModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateSubLocation(id: Int, code: String, nameAR: String, nameEN: String, locationID: Int) {
        didChangeLoading?(true)
        client.request(api: .updateSubLocation(id: id, code: code, nameAR: nameAR, nameEN: nameEN, locationID: locationID), modelType: AddUpdateSubLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateSubLocationModel):
                self?.didAddUpdateSubLocation?(addUpdateSubLocationModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
