//
//  BirdLocation.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

enum BirdLocation: String, CaseIterable {
    case all              = "f_habitats"
    case naselje          = "f_naselja"
    case njiva            = "f_njive"
    case suma             = "f_sume"
    case liticaKamenjar   = "f_kamenjari"
    case livada           = "f_travnjaci"
    case voda             = "f_vodena"
    case zbun             = "f_sikare"
    case mesovitiPredeo   = "f_mesovita"
}

struct LocationItem: Item {
    let location: BirdLocation
    var image: String { return location.rawValue }
    var text: String {
        switch location {
        case .all:              return "Pretraži sve predele"
        case .naselje:          return "U naselju"
        case .njiva:            return "Na njivi"
        case .suma:             return "U šumi"
        case .liticaKamenjar:   return "Pored litica i kamenjara"
        case .livada:           return "Na livadi"
        case .voda:             return "Pored vode ili u vodi"
        case .zbun:             return "U žbunju"
        case .mesovitiPredeo:   return "U mešovitom predelu"
        }
    }
}
