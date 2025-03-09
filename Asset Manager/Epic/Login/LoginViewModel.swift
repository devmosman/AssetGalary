//
//  LoginViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 17/06/2022.
//

import Foundation

class LoginViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didSuccessfullyLogin: ((LoginModel) -> ())?
    
    func login(username: String, password: String) {
        didChangeLoading?(true)
        client.request(api: .login(username: username, password: password), modelType: LoginModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let loginModel):
                self?.didSuccessfullyLogin?(loginModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
