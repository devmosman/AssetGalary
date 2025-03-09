//
//  AddEditLocationsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class AddEditLocationsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didAddUpdateLocation: ((AddUpdateLocationModel) -> ())?
    
    func addLocation(code: String, nameAR: String, nameEN: String) {
        didChangeLoading?(true)
        client.request(api: .addLocation(code: code, nameAR: nameAR, nameEN: nameEN), modelType: AddUpdateLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateLocationModel):
                self?.didAddUpdateLocation?(addUpdateLocationModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateLocation(id: Int, code: String, nameAR: String, nameEN: String) {
        didChangeLoading?(true)
        client.request(api: .updateLocation(id: id, code: code, nameAR: nameAR, nameEN: nameEN), modelType: AddUpdateLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateLocationModel):
                self?.didAddUpdateLocation?(addUpdateLocationModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
