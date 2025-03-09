//
//  AddEditSubCategoriesViewModel.swift
//  Asset Manager
//
//  Created by Marwan on 18/06/2022.
//

import Foundation

class AddEditSubCategoriesViewModel {
    
    let client = NetworkClient()
    
    var didReceiveError: ((String) -> ())?
    var didChangeLoading: ((Bool) -> ())?
    var didFetchCategories: (([CategoryModelData]) -> ())?
    var didAddUpdateSubCategory: ((AddUpdateSubCategoryModel) -> ())?

    
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
    
    func addSubCategory(code: String, nameAR: String, nameEN: String, categoryID: Int) {
        didChangeLoading?(true)
        client.request(api: .addSubCategory(code: code, nameAR: nameAR, nameEN: nameEN, categoryID: categoryID), modelType: AddUpdateSubCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateSubCategoryModel):
                self?.didAddUpdateSubCategory?(addUpdateSubCategoryModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
    func updateSubCategory(id: Int, code: String, nameAR: String, nameEN: String, categoryID: Int) {
        didChangeLoading?(true)
        client.request(api: .updateSubCategory(id: id, code: code, nameAR: nameAR, nameEN: nameEN, categoryID: categoryID), modelType: AddUpdateSubCategoryModel.self) { [weak self] result in
            self?.didChangeLoading?(false)
            switch result {
            case .success(let addUpdateSubCategoryModel):
                self?.didAddUpdateSubCategory?(addUpdateSubCategoryModel)
            case .failure(let error):
                self?.didReceiveError?(error.desc)
            }
        }
    }
    
}
