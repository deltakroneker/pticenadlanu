//
//  Shape.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

enum BirdShape: String, CaseIterable {
    case all            = "f_shapes"
    case capljaRoda     = "f_capljolike"
    case detlic         = "f_detlici"
    case grabljivica    = "f_grabljivice"
    case galeb          = "f_galebovi"
    case golub          = "f_golubolike"
    case fazanKokoska   = "f_kokosi"
    case lasta          = "f_laste"
    case patkaLabud     = "f_patkolike"
    case vrabac         = "f_pevacice"
    case barskaKoka     = "f_sljukarice"
    case sova           = "f_sove"
    case vrana          = "f_vranolike"
}

struct ShapeItem: Item  {
    let shape: BirdShape
    var image: String { return shape.rawValue }
    var text: String {
        switch shape {
        case .all:            return "Pretraži sve oblike"
        case .capljaRoda:     return "Čaplju ili rodu"
        case .detlic:         return "Detlića"
        case .grabljivica:    return "Grabljivicu"
        case .galeb:          return "Galeba"
        case .golub:          return "Goluba"
        case .fazanKokoska:   return "Fazana ili kokošku"
        case .lasta:          return "Lastu"
        case .patkaLabud:     return "Patku ili labuda"
        case .vrabac:         return "Vrapca"
        case .barskaKoka:     return "Barsku koku"
        case .sova:           return "Sovu"
        case .vrana:          return "Vranu"
        }
    }
}
