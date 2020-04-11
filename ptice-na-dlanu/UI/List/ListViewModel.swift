//
//  ListViewModel.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/14/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ListViewModel {
    
    var matchedBirds = BehaviorRelay<[BirdItem]>(value: [])
    
    struct Input {
        let searchText: Observable<String>
    }
    
    struct Output {
        let matchedBirdsData: Observable<[SectionModel<String, BirdItem>]>
        let resultCountTitle: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let birdData = Observable.combineLatest(matchedBirds, input.searchText)
            .map({ (matchedBirds, searchText) -> [BirdItem] in
                matchedBirds.filter { self.birdSearchFilter(bird: $0.bird, text: searchText) }
            })
            .share()
            
        let birdDataSource = birdData
            .map { [SectionModel<String, BirdItem>.init(model: "", items: $0)] }

        let resultCountTitle = birdData
            .map { $0.count.description }
            .map { ($0.last == "1" && $0.dropLast().last != "1") ? "\($0) REZULTAT" : "\($0) REZULTATA" }
        
        return Output(matchedBirdsData: birdDataSource, resultCountTitle: resultCountTitle)
    }
    
    func birdSearchFilter(bird: Bird, text: String) -> Bool {
        guard !text.isEmpty else { return true }
        
        let foundInSrpskiNazivVrste = bird.srpskiNazivVrste.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        let foundInPorodica = bird.srpskiNazivVrste.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        let foundInNaucniNazivVrste = bird.naucniNazivVrste.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        let foundInSinonimi = bird.sinonimi.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        let foundInEnglish = bird.engleskiNazivVrste.range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil

        return foundInSrpskiNazivVrste || foundInPorodica || foundInNaucniNazivVrste || foundInSinonimi || foundInEnglish
    }
}
