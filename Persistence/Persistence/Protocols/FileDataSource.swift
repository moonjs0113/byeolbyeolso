//
//  FileDataSource.swift
//  Persistence
//
//  Created by 문종식 on 6/18/25.
//

import Foundation

public enum FileType {
    case thumbnail
    case image
    case json
    case mp3

    var fileExtension: String {
        switch self {
        case .thumbnail: "png"
        case .image: "png"
        case .json: "json"
        case .mp3: "mp3"
        }
    }

    var suffix: String {
        switch self {
        case .thumbnail: "_thumbnail"
        default: ""
        }
    }
}

public protocol FileDataSource {
    func saveFile(from data: Data, name: String, type: FileType) throws
    func loadFile(name: String, type: FileType) throws -> Data
}
