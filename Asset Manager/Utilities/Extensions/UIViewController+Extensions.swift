//
//  UIViewController+Extensions.swift
//  Asset Manager
//
//  Created by Osama Hassan on 20/11/2023.
//

import Foundation
import UIKit

extension UIViewController{
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func confirmationAlert (_ title: String, andLocalizedMessage message: String,OkBtnLocalizedTitle okBtnTitle: String,CancelBtnLocalizedTitle cancelBtnTitle: String?, completion:@escaping (_ result:Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        
        paragraphStyle.alignment = .right;
        
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: okBtnTitle , style: .default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: { action in
            completion(false)
        }))
    }
}
