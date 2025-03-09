//
//  .swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class LocationsViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchLocations: (([LocationModelData], Bool) -> ())?
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalLocations = 0
    
    func fetchLocations(filter: [String:Any], paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting Locations with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filter["name"] as? String ?? ""
        client.request(api: .fetchLocations(filter: name, page: page, size: 5), modelType: LocationModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let locationModel):
                self?.totalLocations = locationModel.totalRowCount ?? 0
                self?.didFetchLocations?(locationModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
}
