//
//  CategoriesViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class CategoriesViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchCategories: (([CategoryModelData], Bool) -> ())?
    
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalCategories = 0
    
    func fetchCategories(filter: [String: Any],paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting Categories with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filter["name"] as? String ?? ""
        client.request(api: .fetchCategories(filter: name, page: page, size: 5), modelType: CategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let categoryModel):
                self?.totalCategories = categoryModel.totalRowCount ?? 0
                self?.didFetchCategories?(categoryModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
}
