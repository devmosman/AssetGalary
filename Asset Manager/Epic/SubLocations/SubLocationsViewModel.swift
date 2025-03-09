//
//  SubLocationsViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class SubLocationsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchSubLocations: (([SubLocationModelData], Bool) -> ())?
    var didFetchLocations: (([LocationModelData]) -> ())?

    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalSubLocations = 0
    
    func fetchSubLocations(filter: [String: Any], paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting SubLocations with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filter["name"] as? String ?? ""
        let id = filter["id"] as? String ?? ""
        client.request(api: .fetchSubLocations(filter: name, page: page, size: 5, locationID: id), modelType: SubLocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let subLocationsModel):
                self?.totalSubLocations = subLocationsModel.totalRowCount ?? 0
                self?.didFetchSubLocations?(subLocationsModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
    func fetchLocations() {
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
    
}
