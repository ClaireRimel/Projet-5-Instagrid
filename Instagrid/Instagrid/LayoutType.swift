//
//  LayoutType.swift
//  Instagrid
//
//  Created by Claire Sivadier on 21/05/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

// Here we define an enum type which its cases describe all posible photo layouts offered by the app. Because of its nature, it allows us to freely create new custom layouts beside the ones defined in the project's specification

// We will use the "CaseIterable" protocol (available since Swift 4.2) in order to use allCases property
enum LayoutType: CaseIterable {
    case oneTopTwoBottom
    case twoTopOneBottom
    case twoTopTwoBottom
    case threeTopThreeCenterThreeBottom
}

extension LayoutType {
    var sections: Int {
        switch self {
        case .oneTopTwoBottom:
            return 2
        case .twoTopOneBottom:
            return 2
        case .twoTopTwoBottom:
            return 2
        case .threeTopThreeCenterThreeBottom:
            return 3
        }
    }
    
    func numberOfItems(for section: Int) -> Int {
        switch section {
        case 0:
            switch self {
            case .oneTopTwoBottom:
                return 1
            case .twoTopOneBottom:
                return 2
            case .twoTopTwoBottom:
                return 2
            case .threeTopThreeCenterThreeBottom:
                return 3
            }
            
        case 1:
            switch self {
            case .oneTopTwoBottom:
                return 2
            case .twoTopOneBottom:
                return 1
            case .twoTopTwoBottom:
                return 2
            case .threeTopThreeCenterThreeBottom:
                return 3
            }
            
        case 2:
            switch self {
            
            case .oneTopTwoBottom:
                return 0
            case .twoTopOneBottom:
                return 0
            case .twoTopTwoBottom:
                return 0
            case .threeTopThreeCenterThreeBottom:
                return 3
            }
        // The current logic only supports 3 sections, so in case of an API misuse we'll provide a default 0 value
        default:
            return 0
        }
    }
}
