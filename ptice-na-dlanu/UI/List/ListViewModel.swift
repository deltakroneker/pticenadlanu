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
    }
    
    struct Output {
        let matchedBirdsData: Observable<[SectionModel<String, BirdItem>]>
    }
    
    func transform(input: Input?) -> Output {
        let birdDataSource = matchedBirds.asObservable()
            .map { [SectionModel<String, BirdItem>.init(model: "", items: $0)] }

        return Output(matchedBirdsData: birdDataSource)
    }
}
