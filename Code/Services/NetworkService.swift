//
//  NetworkService.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation

protocol NetworkServicing: class {
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
}
