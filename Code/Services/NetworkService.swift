//
//  NetworkService.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkServicing: class {
    func executeRequest(url: URL) -> Single<Data>
    func executeRequest(url: URL, resultHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService: NetworkServicing {
    private let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func executeRequest(url: URL, resultHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                resultHandler(.failure(NetworkError(errorDescription: error.localizedDescription)))
            } else if let data = data {
                resultHandler(.success(data))
            } else {
                resultHandler(.failure(NetworkError(errorDescription: "Unknown Error")))
            }
        }
        
        task.resume()
    }
    
    func executeRequest(url: URL) -> Single<Data> {
        return Single.create(subscribe: { [weak self] single -> Disposable in
            guard let self = self else {
                single(.error(NetworkError(errorDescription: "Unknown Error")))
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.error(error))
                } else if let data = data {
                    single(.success(data))
                } else {
                    single(.error(NetworkError(errorDescription: "Unknown Error")))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
