//
//  DropDown+Extensions.swift
//  Asset Manager
//
//  Created by Marwan on 24/06/2022.
//

import Foundation
import iOSDropDown

extension DropDown {
    
    open override func awakeFromNib() {
        self.selectedRowColor = UIColor.black.withAlphaComponent(0.2)
        self.arrowSize = 12
        self.arrowColor = .black
    }
    
}
