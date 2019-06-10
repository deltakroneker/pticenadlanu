//
//  HomeViewModel.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import SwiftCSV

class HomeViewModel {
    
    var colorSelected = BehaviorSubject<FeatherColor?>(value: nil)
    
    struct Input {
    }
    
    struct Output {
        let newShapeData: Observable<[SectionModel<String, ShapeItem>]>
        let newLocationData: Observable<[SectionModel<String, LocationItem>]>
        
        let isButtonEnabled: Observable<Bool>
        let buttonLabelText: Observable<String>
    }
    
    func transform(input: Input?) -> Output {
        let shapeItems = BirdShape.allCases.map { ShapeItem(shape: $0) }
        let shapeDataSource = Observable.just(shapeItems)
            .map { [SectionModel<String, ShapeItem>.init(model: "", items: $0)] }
        
        let locationItems = BirdLocation.allCases.map { LocationItem(location: $0) }
        let locationDataSource = Observable.just(locationItems)
            .map { [SectionModel<String, LocationItem>.init(model: "", items: $0)] }

        let isButtonEnabled = colorSelected
            .map { $0 == nil ? false : true }

        let buttonText = colorSelected.asObservable()
            .map { $0 == nil ? "0 REZULTATA" : $0!.rawValue }
        
        
        
        return Output(newShapeData: shapeDataSource,
                      newLocationData: locationDataSource,
                      isButtonEnabled: isButtonEnabled,
                      buttonLabelText: buttonText)
    }

}

extension HomeViewModel {
    
    func numberOfBirds(for color: FeatherColor, _ bird: BirdShape, in location: BirdLocation) -> Int {
        do {
            if let path = Bundle.main.path(forResource: "scheme", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONDecoder().decode([Scheme].self, from: data)
                print(json)
            }
        } catch {
            
        }
        
        return 0
    }
}
