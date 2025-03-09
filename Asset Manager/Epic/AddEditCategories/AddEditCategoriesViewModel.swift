//
//  AddEditCategoriesViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class AddEditCategoriesViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didAddUpdateCategory: ((AddUpdateCategoryModel) -> ())?
    
    func addCategory(code: String, nameAR: String, nameEN: String) {
        didChangeLoading?(true)
        client.request(api: .addCategory(code: code, nameAR: nameAR, nameEN: nameEN), modelType: AddUpdateCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateCategoryModel):
                self?.didAddUpdateCategory?(addUpdateCategoryModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateCategory(id: Int, code: String, nameAR: String, nameEN: String) {
        didChangeLoading?(true)
        client.request(api: .updateCategory(id: id, code: code, nameAR: nameAR, nameEN: nameEN), modelType: AddUpdateCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateCategoryModel):
                self?.didAddUpdateCategory?(addUpdateCategoryModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
