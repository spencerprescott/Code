//
//  Photo.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let farm: Int
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    
    var assetUrl: URL? {
        let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        return URL(string: url)
    }
}

private struct PhotoResponse {
    let photos: [Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
}

extension PhotoResponse: Decodable {
    enum Key: String, CodingKey {
        enum NestedKey: String, CodingKey {
            case photo
            case page
        }
        case photos
    }
    init(from decoder: Decoder) throws {
        let metadataContainer = try decoder.container(keyedBy: Key.self)
        let photosContainer = try metadataContainer.nestedContainer(keyedBy: Key.NestedKey.self, forKey: .photos)
        let photos = try photosContainer.decode([Photo].self, forKey: .photo)
        self.init(photos: photos)
    }
}

final class PhotoResponseParser {
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func parsePhotos() throws -> [Photo] {
        let decoder = JSONDecoder()
        return try decoder.decode(PhotoResponse.self, from: data).photos
    }
}
