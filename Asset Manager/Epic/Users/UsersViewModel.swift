//
//  UsersViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

class UsersViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchUsers: (([UserModelData], Bool) -> ())?
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalUsers = 0
    
    func fetchUsers(filter: [String:Any], paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting Users with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filter["name"] as? String ?? ""
        client.request(api: .fetchUsers(filter: name, page: page, size: 5), modelType: UserModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let userModel):
                self?.totalUsers = userModel.totalRowCount ?? 0
                self?.didFetchUsers?(userModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
}
