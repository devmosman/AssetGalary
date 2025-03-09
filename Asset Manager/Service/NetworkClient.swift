//
//  NetworkClient.swift
//  WegooDriver
//
//  Created by Marwan on 22/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import Foundation
import Alamofire

class NetworkClient {
    
    private let session: Session!
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Codable>(api: APIRouter, modelType: T.Type, completion: @escaping ((Result<T,NetworkError>) -> Void)) {
        // check for network connection
        let reachability = try? Reachability()
        if reachability?.connection == .unavailable {
            completion(.failure(.noInternet))
            return
        }
        
        session.request(api, interceptor: NetworkInterceptor())
            .validate()
            .responseData { response in
                
                guard let statusCode = (response.response?.statusCode) else {
                    completion(.failure(.server(desc: "No Status Code", statusCode: 0)))
                    return
                }
                
                switch response.result {
                case .success(let data):
                    
                    guard !data.isEmpty else {
                        completion(.failure(.server(desc: "Empty Data", statusCode: statusCode)))
                        return
                    }
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(obj))
                    } catch {
                        print("Parsing Error \(error)")
                        completion(.failure(.invalidData))
                    }
                case .failure(let error):
                    print("Status Code \(statusCode)")
                    if statusCode == 404 {
                        completion(.failure(.notFound))
                    } else {
                        completion(.failure(.server(desc: error.localizedDescription, statusCode: statusCode)))
                    }
                }
                
                
            }
        
    }
    
}
