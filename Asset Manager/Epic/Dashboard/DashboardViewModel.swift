//
//  DashboardViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 20/06/2022.
//

import Foundation

class DashboardViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchDashboardData: ((DashboardModel) -> ())?
    
    func fetchDashboardData() {
        didChangeLoading?(true)
        client.request(api: .getDashboard, modelType: DashboardModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let dashboardModel):
                self?.didFetchDashboardData?(dashboardModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
