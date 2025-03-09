//
//  SideMenuItem.swift
//  Buzzer
//
//  Created by Marwan on 30/05/2022.
//

import Foundation
import UIKit

enum SideMenuItem: CaseIterable {
    
    case categories
    case subCategories
    case Location
    case subLocations
    case Vendor
    case Users
    case dashboard
    case resetPassword
    case settings
    case logout

    
    
    var title: String {
        switch self {
        case .categories: return "Categories"
        case .subCategories: return "Sub-Categories"
        case .Location: return "Locations"
        case .subLocations: return "Sub-Locations"
        case .Vendor: return "Artists"
        case .Users: return "Users"
        case .dashboard: return "Dashboard"
        case .resetPassword: return "Reset Password"
        case .settings: return "Settings"
        case .logout: return "Logout"
       
        }
    }
}
