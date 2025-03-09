//
//  APIRouter.swift
//  WegooDriver
//
//  Created by Marwan on 22/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import Foundation
import Alamofire


protocol APIConfigurationProtocol: URLRequestConvertible {
    
    var parameters: Parameters { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    
    func asURLRequest() throws -> URLRequest
    
}

enum APIRouter: APIConfigurationProtocol {
    
    case login(username: String, password: String)
    case resetPassword(username: String, newPassword: String)
    
    case fetchCategories(filter: String, page: Int, size: Int)
    case addCategory(code: String, nameAR: String, nameEN: String)
    case updateCategory(id: Int, code: String, nameAR: String, nameEN: String)
    
    
    case fetchSubCategories(filter: String, page: Int, size: Int, categoryID: String)
    case addSubCategory(code: String, nameAR: String, nameEN: String, categoryID: Int)
    case updateSubCategory(id: Int, code: String, nameAR: String, nameEN: String, categoryID: Int)
    
    case fetchLocations(filter: String, page: Int, size: Int)
    case addLocation(code: String, nameAR: String, nameEN: String)
    case updateLocation(id: Int, code: String, nameAR: String, nameEN: String)
    
    case fetchSubLocations(filter: String, page: Int, size: Int, locationID: String)
    case addSubLocation(code: String, nameAR: String, nameEN: String, locationID: Int)
    case updateSubLocation(id: Int, code: String, nameAR: String, nameEN: String, locationID: Int)
    
    case fetchVendors(filter: String, page: Int, size: Int)
    case addVendor(address: String, nameAR: String, nameEN: String, notes: String)
    case updateVendor(id: Int, address: String, nameAR: String, nameEN: String, notes: String)
    
    case fetchUsers(filter: String, page: Int, size: Int)
    case addUser(userName: String, email: String, mobile: String, fullName: String, shortName: String, status: Int, password: String, role: String)
    case updateUser(id: Int, userName: String, email: String, mobile: String, fullName: String, shortName: String, status: Int, password: String, role: String)
    
    
    case fetchAssets(filter: String, page: Int, size: Int, locID: String, subLocID: String, catID: String, subCatID: String, vendID: String)
    case fetchAssetByID(assetID: Int)
    case fetchAssetByBarcode(code: String)
    case addAsset(assetUIModel: AddAssetUIModel)
    case updateAsset(assetUIModel: UpdateAssetUIModel)
    case generateQRAsset(code: String)
    case addAssetImage(assetID: Int, base64Image: String, name: String)
    case getAssetImages(assetID: Int)
    
    case getAssetUnits
    case getAssetCurrency
    case getAssetActivity(assetID: Int)
    
    case getDashboard
    case deleteAssetByID(assetID: Int)
    
    var baseURL: String {
        switch self {
        default:
            return LocalData().baseURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .resetPassword:
            return "User/ResetPassowrd"
            
        case .fetchCategories, .addCategory, .updateCategory:
            return "Categories"
            
        case .fetchSubCategories, .addSubCategory, .updateSubCategory:
            return "SubCategories"
            
        case .fetchLocations, .addLocation, .updateLocation:
            return "Locations"
            
        case .fetchSubLocations, .addSubLocation, .updateSubLocation:
            return "SubLocation"
            
        case .fetchVendors, .addVendor, .updateVendor:
            return "Vendors"
            
        case .fetchUsers, .addUser, .updateUser:
            return "User"
            
        case .fetchAssets, .addAsset, .updateAsset:
            return "Asset"
            
        case .fetchAssetByID(let assetID):
            return "Asset/\(assetID)"
            
        case .fetchAssetByBarcode(let code):
            return "Asset/barcode/\(code)"
            
        case .generateQRAsset(let code):
            return "Asset/GenerateQRBarcode/\(code)"
            
        case .addAssetImage(let assetID, _, _):
            return "Asset/\(assetID)/Images"
         
        case .getAssetImages(let assetID):
            return "Asset/\(assetID)/Images"
            
        case .getAssetUnits:
            return "Asset/Unite"
            
        case .getAssetCurrency:
            return "Asset/Currency"
            
        case .getAssetActivity(let assetID):
            return "Asset/\(assetID)/Activity"
            
        case .getDashboard:
            return "Asset/Dashboard"
         
        case .deleteAssetByID(let assetID):
            return "Asset/delete/\(assetID)"
            
        }
    }
    
    
    var parameters: Parameters {
        switch self {
        case .login(let username, let password):
            return [
                "username": username,
                "Password": password
            ]
            
        case .resetPassword(let username, let newPassword):
            return [
                "username": username,
                "NewPassword": newPassword
            ]
            
        case .fetchCategories(let filter, let page, let size):
            return [
                "filter": filter,
                "page": page,
                "size": size
            ]
            
        case .addCategory(let code, let nameAR, let nameEN):
            return [
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN
            ]
        case .updateCategory(let id, let code, let nameAR, let nameEN):
            return [
                "id": id,
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN
            ]
            
        case .fetchSubCategories(let filter, let page, let size, let categoryID):
            return [
                "filter": filter,
                "page": page,
                "size": size,
                "CategoryId": categoryID
            ]
            
        case .addSubCategory(let code, let nameAR, let nameEN, let categoryID):
            return [
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "CategoryId": categoryID
            ]
            
        case .updateSubCategory(let id, let code, let nameAR, let nameEN, let categoryID):
            return [
                "id": id,
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "CategoryId": categoryID
            ]
            
            
        case .fetchLocations(let filter, let page, let size):
            return [
                "filter": filter,
                "page": page,
                "size": size
            ]
            
        case .addLocation(let code, let nameAR, let nameEN):
            return [
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN
            ]
            
        case .updateLocation(let id, let code, let nameAR, let nameEN):
            return [
                "id": id,
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN
            ]
            
        case .fetchSubLocations(let filter, let page, let size, let locationID):
            return [
                "filter": filter,
                "page": page,
                "size": size,
                "LocationId": locationID
            ]
            
        case .addSubLocation(let code, let nameAR, let nameEN, let locationID):
            return [
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "LocationId": locationID
            ]
        case .updateSubLocation(let id, let code, let nameAR, let nameEN, let locationID):
            return [
                "id": id,
                "code": code,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "LocationId": locationID
            ]
            
        case .fetchVendors(let filter, let page, let size):
            return [
                "filter": filter,
                "page": page,
                "size": size
            ]
            
        case .addVendor(let address, let nameAR, let nameEN, let notes):
            return [
                "address": address,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "notes": notes
            ]
        case .updateVendor(let id, let address, let nameAR, let nameEN, let notes):
            return [
                "id": id,
                "address": address,
                "nameAr": nameAR,
                "nameEn": nameEN,
                "notes": notes
            ]
            
        case .fetchUsers(let filter, let page, let size):
            return [
                "filter": filter,
                "page": page,
                "size": size
            ]
            
        case .addUser(let username, let email, let mobile, let fullname, let shortname, let status, let password, let role):
            return [
                "userName": username,
                "password": password,
                "email": email,
                "mobile": mobile,
                "fullName": fullname,
                "shortName": shortname,
                "status": status,
                "userRole": role
            ]
            
        case .updateUser(let id, let username, let email, let mobile, let fullname, let shortname, let status, let password, let role):
            return [
                "id": id,
                "userName": username,
                "password": password,
                "email": email,
                "mobile": mobile,
                "fullName": fullname,
                "shortName": shortname,
                "status": status,
                "userRole": role
            ]
            
            
        case .fetchAssets(let filter, let page, let size, let locID, let subLocID, let catID, let subCatID, let vendID):
            return [
                "filter": filter,
                "page": page,
                "size": size,
                "locationId": locID,
                "subLocationId": subLocID,
                "categoryId": catID,
                "subCategoryId": subCatID,
                "vendorID": vendID
            ]
            
        case .addAsset(let asset):
            return asset.asDictionary()
            
        case .updateAsset(let asset):
            return asset.asDictionary()
            
        case .addAssetImage(_ , let base64Image, let name):
            return [
                "fileName": name,
                "fileData": base64Image
            ]
            
        default:
            return [:]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login: return ["Content-Type":"application/json"]
        default:
            return [
                "Authorization": "Bearer " + LocalData().authToken,
                "Content-Type":"application/json",
                "Accept":"application/json"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .resetPassword: return .post
        case .addCategory, .updateCategory: return .post
        case .addSubCategory, .updateSubCategory: return .post
        case .addLocation, .updateLocation: return .post
        case .addSubLocation, .updateSubLocation: return .post
        case .addVendor, .updateVendor: return .post
        case .addUser, .updateUser: return .post
        case .addAsset, .updateAsset, .addAssetImage: return .post
        case .deleteAssetByID: return .post
        default:
            return .get
        }
    }
    
    
    
    func asURLRequest() throws -> URLRequest {
        let urlString = baseURL + path
        let formattedURL = urlString.replacingOccurrences(of: " ", with: "%20")
        let url = try formattedURL.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        
        
        print("### Request API \(urlString) ###")
        print("### Request Method \(method.rawValue) ###")
        print("### Request Headers \(headers) ###")
        print("### Request Parameters \(parameters) ###")
        
        switch method {
        case .get, .delete:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
    
    
    
    
}
