//
//  AddEditUserViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

class AddEditUserViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didAddUpdateUser: ((AddUpdateUserModel) -> ())?
    
    func addUser(userName: String, password: String, email: String, mobile: String, fullName: String, shortName: String, status: Int, role: String) {
        didChangeLoading?(true)
        client.request(api: .addUser(userName: userName, email: email, mobile: mobile, fullName: fullName, shortName: shortName, status: status, password: password, role: role), modelType: AddUpdateUserModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateUserModel):
                self?.didAddUpdateUser?(addUpdateUserModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateUser(id: Int, userName: String, password: String, email: String, mobile: String, fullName: String, shortName: String, status: Int, role: String) {
        didChangeLoading?(true)
        client.request(api: .updateUser(id: id, userName: userName, email: email, mobile: mobile, fullName: fullName, shortName: shortName, status: status, password: password, role: role), modelType: AddUpdateUserModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateUserModel):
                self?.didAddUpdateUser?(addUpdateUserModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
