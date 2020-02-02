//
//  DetailsViewModel.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 7/15/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class DetailsViewModel {
    
    var birdItem = BehaviorRelay<BirdItem?>(value: nil)
    
    struct Input {
    }
    
    struct Output {
        let imagesData: Observable<[SectionModel<String, String>]>
        let isPageControlHidden: Observable<Bool>
        let numberOfPages: Observable<Int>
    }
    
    func transform(input: Input?) -> Output {
        let images = birdItem.asObservable()
            .map { ($0?.gender == Gender.female ? $0?.femaleImages : $0?.images) ?? [] }
            
        let imageDataSource = images
            .map { [SectionModel<String, String>.init(model: "", items: $0)] }
        
        let isPageControlHidden = images
            .map { $0.count == 1 }
        
        let numberOfPages = images
            .map { $0.count }
        
        return Output(imagesData: imageDataSource,
                      isPageControlHidden: isPageControlHidden,
                      numberOfPages: numberOfPages)
    }
}
