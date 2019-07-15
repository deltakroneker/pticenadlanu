//
//  HomeViewModel.swift
//  ptice-na-dlanu
//
//  Created by Nikola Milic on 4/10/19.
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import SwiftCSV

class HomeViewModel {
    
    var selectedColors = BehaviorRelay<[FeatherColor]>(value: [])
    
    struct Input {
        let shape: Observable<BirdShape?>
        let location: Observable<BirdLocation?>
    }
    
    struct Output {
        let newShapeData: Observable<[SectionModel<String, ShapeItem>]>
        let newLocationData: Observable<[SectionModel<String, LocationItem>]>
        
        let matchingBirds: Observable<[BirdItem]>

        let isButtonEnabled: Observable<Bool>
        let buttonLabelText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let shapeItems = BirdShape.allCases.map { ShapeItem(shape: $0) }
        let shapeDataSource = Observable
            .just(shapeItems)
            .map { [SectionModel<String, ShapeItem>.init(model: "", items: $0)] }
        
        let locationItems = BirdLocation.allCases.map { LocationItem(location: $0) }
        let locationDataSource = Observable
            .just(locationItems)
            .map { [SectionModel<String, LocationItem>.init(model: "", items: $0)] }

        let matchingBirds = Observable
            .combineLatest(selectedColors.asObservable(), input.shape, input.location)
            .map { [weak self] (colors, shape, location) -> [Bird] in
                guard let self = self, let shape = shape, let location = location else { return [] }
                return self.getBirds(with: colors, shape, location)
            }
            .map { $0.map { BirdItem(bird: $0, gender: .noGender) } }
            .map { birdItems -> [BirdItem] in
                var newBirdItems = birdItems
                for (index,item) in birdItems.enumerated() {
                    if item.hasFemaleVersion {
                        var femaleItem = item
                        femaleItem.gender = .female
                        newBirdItems[index].gender = .male
                        newBirdItems.insert(femaleItem, at: index + 1)
                    }
                }
                return newBirdItems
            }
            .share()
        
        let isButtonEnabled = matchingBirds
            .map { $0.count == 0 ? false : true }
        
        let buttonText = matchingBirds
            .map { $0.count.description }
            .map { ($0.last == "1" && $0.dropLast().last != "1") ? "\($0) REZULTAT" : "\($0) REZULTATA" }
            
        return Output(newShapeData: shapeDataSource,
                      newLocationData: locationDataSource,
                      matchingBirds: matchingBirds,
                      isButtonEnabled: isButtonEnabled,
                      buttonLabelText: buttonText)
    }

}

extension HomeViewModel {
    
    func getBirds(with colors: [FeatherColor], _ shape: BirdShape, _ location: BirdLocation) -> [Bird] {
        do {
            if let path = Bundle.main.path(forResource: "scheme", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let birds = try JSONDecoder().decode([Bird].self, from: data)
                
                var filteredBirds = [Bird]()
                for bird in birds {
                    
                    let colorSatisfied = Set(bird.featherColorArray).intersection(colors).count > 0 || colors.isEmpty
                    let shapeSatisfied = bird.shapeArray.contains(shape) || shape == .all
                    let locationSatisfied = bird.locationArray.contains(location) || location == .all
                    
                    if colorSatisfied && shapeSatisfied && locationSatisfied {
                        filteredBirds.append(bird)
                    }
                    
                }
                return filteredBirds
            }
        } catch {}
        return []
    }
}
