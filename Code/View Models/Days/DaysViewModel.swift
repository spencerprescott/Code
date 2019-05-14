//
//  DaysViewModel.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DaysViewModelInput: class {
    var currentIndex: PublishSubject<Int> { get }
}

protocol DaysViewModelOutput: class {
    var photos: Observable<[PhotoViewModel]> { get }
    var currentDay: Observable<String?> { get }
}

protocol DaysViewModelType: class {
    var input: DaysViewModelInput { get }
    var output: DaysViewModelOutput { get }
}

extension DaysViewModelType where Self: DaysViewModelInput {
    var input: DaysViewModelInput { return self }
}

extension DaysViewModelType where Self: DaysViewModelOutput {
    var output: DaysViewModelOutput { return self }
}

final class DaysViewModel: DaysViewModelType, DaysViewModelInput, DaysViewModelOutput {
    private let _days: [Date] = {
        // From today to a month back
        let today = Date()
        return (0..<31)
            .map { today.addingDays(-$0) }
    }()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var currentDay: Observable<String?> {
        let daysObservable = Observable.just(_days)
        return Observable
            .combineLatest(daysObservable, currentIndex.asObservable())
            .map { [weak self] dates, index in
                self?.dateFormatter.string(from: dates[index])
            }
    }
    
    var photos: Observable<[PhotoViewModel]> {
        let viewModels = _days
            .map { PhotoViewModel(dateRange: .init(min: $0, max: $0)) }
        return .just(viewModels)
    }
    
    let currentIndex = PublishSubject<Int>()
}
