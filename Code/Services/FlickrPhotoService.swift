//
//  FlickrPhotoService.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation
import RxSwift

struct DateRange {
    let min: Date
    let max: Date
}

protocol FlickrPhotoServicing: class {
    func searchPhotos(dateRange: DateRange) -> Single<[Photo]>
}

final class FlickrPhotoService: FlickrPhotoServicing {
    private let networkService: NetworkServicing
    private let urlFactory = FlickrUrlFactory(apiKey: "da736491e2087b749d0ffe25298a5f05")
    
    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchPhotos(dateRange: DateRange) -> Single<[Photo]> {
        guard let url = urlFactory.url(method: .search(dateRange: dateRange)) else {
            return .error(NetworkError(errorDescription: "Invalid Date Range"))
        }

        return networkService
            .executeRequest(url: url)
            .flatMap(parseData)
    }
    
    func searchPhotos(dateRange: DateRange, resultHandler: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = urlFactory.url(method: .search(dateRange: dateRange))
            else { return resultHandler(.failure(NetworkError(errorDescription: "Invalid Date Range"))) }
        
        networkService.executeRequest(url: url) { [weak self] result in
            guard let self = self
                else { return resultHandler(.failure(NetworkError(errorDescription: nil))) }
            
            switch result {
            case .success(let data):
                guard let cleanedData = self.removeFlickrPadding(from: data)
                    else { return resultHandler(.failure(NetworkError(errorDescription: "Invalid JSON"))) }
                do {
                    let parser = PhotoResponseParser(data: cleanedData)
                    let photos = try parser.parsePhotos()
                    resultHandler(.success(photos))
                } catch {
                    Log.error(error.localizedDescription)
                    resultHandler(.failure(error))
                }
            case .failure(let error):
                Log.error(error.localizedDescription)
                resultHandler(.failure(error))
            }
        }
        
    }
    
    private func parseData(_ data: Data) -> Single<[Photo]> {
        return .create(subscribe: { single -> Disposable in
            guard let cleanedData = self.removeFlickrPadding(from: data) else {
                single(.error(NetworkError(errorDescription: "Invalid JSON")))
                return Disposables.create()
            }
            
            do {
                let parser = PhotoResponseParser(data: cleanedData)
                let photos = try parser.parsePhotos()
                single(.success(photos))
            } catch {
                Log.error(error.localizedDescription)
                single(.error(error))
            }
            
            return Disposables.create()
        })
    }
    
    /// Helper to remove outdated padding technique Flickr does to all their JSON response :(
    private func removeFlickrPadding(from data: Data) -> Data? {
        guard let string = String(data: data, encoding: .utf8),
            var startPadding = string.firstIndex(of: "("),
            let endPadding = string.lastIndex(of: ")")
            else { return nil }
        startPadding = string.index(after: startPadding)
        // json is padded with jsonFlickrApi( and ended with )
        let json = String(string[startPadding..<endPadding])
        return json.data(using: .utf8)
    }
}

private final class FlickrUrlFactory {
    enum Method {
        case search(dateRange: DateRange)
        
        var url: String {
            switch self {
            case .search(let dateRange):
                return "?method=flickr.photos.search&min_upload_date=\(dateRange.min.timeIntervalSince1970)&max_upload_date=\(dateRange.max.timeIntervalSince1970)&per_page=1"
            }
        }
    }
    
    private let baseUrl = "https://api.flickr.com/services/rest/"
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func url(method: Method) -> URL? {
        var url = method.url
        url.append("&api_key=\(apiKey)&format=json")
        return URL(string: baseUrl + url)
    }
}
