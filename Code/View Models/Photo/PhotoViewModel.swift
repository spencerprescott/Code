
//
//  PhotoViewModel.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoViewModelInput: class {
    
}

protocol PhotoViewModelOutput: class {
    var photo: Observable<Photo?> { get }
}

protocol PhotoViewModelType: class {
    var input: PhotoViewModelInput { get }
    var output: PhotoViewModelOutput { get }
}

extension PhotoViewModelType where Self: PhotoViewModelInput {
    var input: PhotoViewModelInput { return self }
}

extension PhotoViewModelType where Self: PhotoViewModelOutput {
    var output: PhotoViewModelOutput { return self }
}

final class PhotoViewModel: PhotoViewModelType, PhotoViewModelInput, PhotoViewModelOutput {
    var photo: Observable<Photo?> {
        return service
            .searchPhotos(dateRange: dateRange)
            .flatMap(selectDailyPhoto)
            .asObservable()
    }
    
    private let service: FlickrPhotoServicing
    private let dateRange: DateRange
    
    init(dateRange: DateRange, service: FlickrPhotoServicing = FlickrPhotoService()) {
        self.dateRange = dateRange
        self.service = service
    }
    
    private func selectDailyPhoto(from photos: [Photo]) -> Single<Photo?> {
        return .just(photos.randomElement())
    }
}
