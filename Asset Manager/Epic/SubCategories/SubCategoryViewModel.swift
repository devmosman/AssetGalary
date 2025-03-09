//
//  SubCategoryViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class SubCategoryViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchSubCategories: (([SubCategoryModelData], Bool) -> ())?
    var didFetchCategories: (([CategoryModelData]) -> ())?
    
    var isPaginating: Bool = false
    var page: Int = 0
    var totalSubCategories = 0
    
    func fetchSubCategories(filter: [String: Any], paging: Bool = false) {
        if paging {
            isPaginating = true
            page += 1
            print("@@@ Getting SubCategories with page \(page)")
        } else {
            page = 0
            didChangeLoading?(true)
        }
        let name = filter["name"] as? String ?? ""
        let id = filter["id"] as? String ?? ""
        client.request(api: .fetchSubCategories(filter: name, page: page, size: 5, categoryID: id), modelType: SubCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let subCategoryModel):
                self?.totalSubCategories = subCategoryModel.totalRowCount ?? 0
                self?.didFetchSubCategories?(subCategoryModel.data ?? [], paging)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
            if paging {
                self?.isPaginating = false
            }
        }
    }
    
    func fetchCategories() {
        didChangeLoading?(true)
        client.request(api: .fetchCategories(filter: "", page: 0, size: 1000), modelType: CategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let categoryModel):
                self?.didFetchCategories?(categoryModel.data ?? [])
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
