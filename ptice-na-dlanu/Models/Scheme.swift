//
//  Scheme.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 5/6/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

struct Scheme: Codable {
    let n: String
    let naucniNazivVrste, srpskiNazivVrste, sinonimi, porodica: String
    let ilustracije, ilustracijeZenke, silueta, staniste: String
    let boje, bojeZenke: String
    let glavniTekst: String
    let duzinaTela, rasponKrila, masa, ishrana: String
    let gnezdaricaNegnezdarica, the1, ugrozena: String
    
    
    var bojeArray: [FeatherColor?] {
        return boje.components(separatedBy: ";").map { FeatherColor.fromScheme(name: $0) }
    }
    var bojeZenkeArray: String {
        return bojeZenke
    }
    
    enum CodingKeys: String, CodingKey {
        case n = "N"
        case naucniNazivVrste = "Naučni naziv vrste"
        case srpskiNazivVrste = "Srpski naziv vrste"
        case sinonimi = "Sinonimi"
        case porodica = "Porodica"
        case ilustracije = "Ilustracije"
        case ilustracijeZenke = "Ilustracije zenke"
        case silueta = "Silueta"
        case staniste = "Staniste"
        case boje = "Boje"
        case bojeZenke = "Boje zenke"
        case glavniTekst = "Glavni tekst"
        case duzinaTela = "Dužina tela (cm)"
        case rasponKrila = "Raspon krila (cm)"
        case masa = "Masa (g)"
        case ishrana = "Ishrana"
        case gnezdaricaNegnezdarica = "Gnezdarica/Negnezdarica"
        case the1 = "__1"
        case ugrozena = "Ugrožena (DA/NE)"
    }
}

