//
//  ResetPasswordViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 19/06/2022.
//

import Foundation

class ResetPasswordViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didResetPassword: ((Bool) -> ())?
    
    func resetPassword(username: String, newPassword: String) {
        didChangeLoading?(true)
        client.request(api: .resetPassword(username: username, newPassword: newPassword), modelType: Bool.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let isSuccess):
                self?.didResetPassword?(isSuccess)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
