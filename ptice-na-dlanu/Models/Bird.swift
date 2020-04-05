//
//  Bird.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 5/6/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

struct Bird: Codable {
    let n: String
    let naucniNazivVrste, srpskiNazivVrste, sinonimi, porodica, engleskiNazivVrste: String
    let ilustracije, ilustracijeZenke, silueta, staniste: String
    let boje, bojeZenke: String
    let glavniTekst: String
    let duzinaTela, rasponKrila, masa, ishrana: String
    let gnezdaricaNegnezdarica, prisutnost, ugrozena, video: String
    let pesma, pesmaZenke, zov, letniZov, zovUzbune, zovMladih, brojZvukova: String
    let autorPesme, autorPesmeZenke, autorZova, autorLetnogZova, autorZovaUzbune, autorZovaMladih: String
    
    var shapeArray: [BirdShape] {
        return silueta.components(separatedBy: ";").compactMap {
            BirdShape.fromScheme(name: $0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    var locationArray: [BirdLocation] {
        return staniste.components(separatedBy: ";").compactMap {
            BirdLocation.fromScheme(name: $0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    var featherColorArray: [FeatherColor] {
        return boje.components(separatedBy: ";").compactMap {
            FeatherColor.fromScheme(name: $0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    var femaleFeatherColorArray: [FeatherColor] {
        return bojeZenke.components(separatedBy: ";").compactMap {
            FeatherColor.fromScheme(name: $0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case n                        = "N"
        case naucniNazivVrste         = "Naučni naziv vrste"
        case srpskiNazivVrste         = "Srpski naziv vrste"
        case sinonimi                 = "Sinonimi"
        case porodica                 = "Porodica"
        case ilustracije              = "Ilustracije"
        case ilustracijeZenke         = "Ilustracije zenke"
        case silueta                  = "Silueta"
        case staniste                 = "Staniste"
        case boje                     = "Boje"
        case bojeZenke                = "Boje zenke"
        case glavniTekst              = "Glavni tekst"
        case duzinaTela               = "Dužina tela (cm)"
        case rasponKrila              = "Raspon krila (cm)"
        case masa                     = "Masa (g)"
        case ishrana                  = "Ishrana"
        case gnezdaricaNegnezdarica   = "Gnezdarica/Negnezdarica"
        case prisutnost               = "Prisutnost"
        case ugrozena                 = "Ugrožena (DA/NE)"
        case video                    = "Video"
        case pesma                    = "Pesma"
        case pesmaZenke               = "Ženka"
        case zov                      = "Zov"
        case letniZov                 = "Let"
        case zovUzbune                = "Uzbuna"
        case zovMladih                = "Mladi"
        case brojZvukova              = "Broj zvukova"
        case autorPesme               = "Autor - pesma"
        case autorPesmeZenke          = "Autor - zov zenke"
        case autorZova                = "Autor - zov"
        case autorLetnogZova          = "Autor  - let"
        case autorZovaUzbune          = "Autor - uzbuna"
        case autorZovaMladih          = "Autor - zov mladih"
        case engleskiNazivVrste       = "Engleski naziv vrste"
    }
}

enum Gender {
    case noGender
    case male
    case female
}

struct BirdItem: Item {
    var bird: Bird
    var gender: Gender
    var genderString: String { return gender == .male ? " (m)" : " (ž)" }
    
    var hasFemaleVersion: Bool { return !bird.ilustracijeZenke.isEmpty }
    var hasDifferentFemaleColors: Bool { return !bird.femaleFeatherColorArray.isEmpty }
    
    var images: [String] {
        return bird.ilustracije.components(separatedBy: ";").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    var femaleImages: [String] {
        return images.reversed()
    }
    var image: String {
        guard let first = images.first, let last = images.last else { return "f_laste" }
        return (gender == .female) ? last : first
    }
    var text: String { return bird.srpskiNazivVrste }
}
