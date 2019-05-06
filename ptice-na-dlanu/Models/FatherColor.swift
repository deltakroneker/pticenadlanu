//
//  FeatherColor.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

enum FeatherColor: String, CaseIterable {
    case black  = "blackCircleSelected"
    case brown  = "brownCircleSelected"
    case beige  = "beigeCircleSelected"
    case grey   = "greyCircleSelected"
    case white  = "whiteCircleSelected"
    case yellow = "yellowCircleSelected"
    case orange = "orangeCircleSelected"
    case red    = "redCircleSelected"
    case blue   = "blueCircleSelected"
    case green  = "greenCircleSelected"
    
    static func fromTag(tag: Int) -> FeatherColor? {
        switch tag {
        case 0: return .black
        case 1: return .brown
        case 2: return .beige
        case 3: return .grey
        case 4: return .white
        case 5: return .yellow
        case 6: return .orange
        case 7: return .red
        case 8: return .blue
        case 9: return .green
        default: return nil
        }
    }
    
    func asInt() -> Int {
        return FeatherColor.allCases.firstIndex(of: self)!
    }
}
