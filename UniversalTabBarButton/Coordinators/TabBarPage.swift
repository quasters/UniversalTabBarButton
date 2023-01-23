//
//  File.swift
//  UniversalTabBarButton
//
//  Created by Наиль Буркеев on 23.01.2023.
//

import Foundation
import UIKit

enum TabBarPage {
    case title0
    case title1
    case title2
    case title3
    
    init?(index: Int) {
        switch index {
        case 0: self = .title0
        case 1: self = .title1
        case 2: self = .title2
        case 3: self = .title3
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .title0:
            return 0
        case .title1:
            return 1
        case .title2:
            return 2
        case .title3:
            return 3
        }
    }
    
    func titleValue() -> String {
        switch self {
        case .title0:
            return "Title0"
        case .title1:
            return "Title1"
        case .title2:
            return "Title2"
        case .title3:
            return "Title3"
        }
    }
    
    func imageValue(isSelected: Bool) -> UIImage? {
        switch self {
        case .title0:
            return UIImage(systemName: isSelected ? "house.circle.fill" : "house.circle")
        case .title1:
            return UIImage(systemName: isSelected ? "seal.fill" : "seal")
        case .title2:
            return UIImage(systemName: isSelected ? "square.fill" : "square")
        case .title3:
            return UIImage(systemName: isSelected ? "pentagon.fill" : "pentagon")
        }
    }
}
