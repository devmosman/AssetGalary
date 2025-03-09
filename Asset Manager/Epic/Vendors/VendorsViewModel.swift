//
//  VendorsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class VendorsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchVendors: (([VendorModelData], Bool) -> ())?
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalVendors = 0
    
    func fetchVendors(filters: [String: Any], paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting Vendors with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filters["name"] as? String ?? ""
        client.request(api: .fetchVendors(filter: name, page: page, size: 5), modelType: VendorModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let vendorModel):
                self?.totalVendors = vendorModel.totalRowCount ?? 0
                self?.didFetchVendors?(vendorModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
}
