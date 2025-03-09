//
//  AddEditVendorsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

class AddEditVendorsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didAddUpdateVendor: ((AddUpdateVendorModel) -> ())?
    
    func addVendor(address: String, nameAR: String, nameEN: String, notes: String) {
        didChangeLoading?(true)
        client.request(api: .addVendor(address: address, nameAR: nameAR, nameEN: nameEN, notes: notes), modelType: AddUpdateVendorModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateVendorModel):
                self?.didAddUpdateVendor?(addUpdateVendorModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateVendor(id: Int, address: String, nameAR: String, nameEN: String, notes: String) {
        didChangeLoading?(true)
        client.request(api: .updateVendor(id: id, address: address, nameAR: nameAR, nameEN: nameEN, notes: notes), modelType: AddUpdateVendorModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateVendorModel):
                self?.didAddUpdateVendor?(addUpdateVendorModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
