//
//  NetworkInterceptor.swift
//  WegooDriver
//
//  Created by Marwan on 22/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import Foundation
import Alamofire

class NetworkInterceptor: RequestInterceptor {
    
    private let retryCount = 2
    
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < retryCount else {
            completion(.doNotRetry)
            return
        }
        
        if let urlString = request.request?.url?.absoluteString,
           !urlString.contains("login"),
           request.response?.statusCode == 401 {
            showSessionTimeOut()
            completion(.doNotRetry)
        }
        
        completion(.retry)
    }
    
}

//MARK: - Helper Methods
extension NetworkInterceptor {
    
    func showSessionTimeOut() {
        DispatchQueue.main.async {
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            LocalData().authToken = ""
            appDel.window!.rootViewController = LoginViewController()
            appDel.window!.makeKeyAndVisible()
        }
        
    }
    
}
