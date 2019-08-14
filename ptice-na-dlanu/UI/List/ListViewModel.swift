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
    }
    
    func transform(input: Input) -> Output {
        let birdDataSource = Observable.combineLatest(matchedBirds, input.searchText)
            .map({ (matchedBirds, searchText) -> [BirdItem] in
                matchedBirds.filter { self.birdSearchFilter(bird: $0.bird, text: searchText) }
            })
            .map { [SectionModel<String, BirdItem>.init(model: "", items: $0)] }

        return Output(matchedBirdsData: birdDataSource)
    }
    
    func birdSearchFilter(bird: Bird, text: String) -> Bool {
        guard !text.isEmpty else { return true }
        
        let foundInSrpskiNazivVrste = bird.srpskiNazivVrste.range(of: text, options: .caseInsensitive) != nil
        let foundInPorodica = bird.srpskiNazivVrste.range(of: text, options: .caseInsensitive) != nil
        let foundInNaucniNazivVrste = bird.naucniNazivVrste.range(of: text, options: .caseInsensitive) != nil

        return foundInSrpskiNazivVrste || foundInPorodica || foundInNaucniNazivVrste
    }
}
