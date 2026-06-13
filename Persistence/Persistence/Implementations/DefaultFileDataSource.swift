//
//  DefaultFileDataSource.swift
//  Persistence
//
//  Created by 문종식 on 6/18/25.
//

import Foundation

struct DefaultFileDataSource: FileDataSource {
    private var fileManager: FileManager {
        FileManager.default
    }

    private func getFileURL(name: String, type: FileType) -> URL {
        let fileName = "\(name)\(type.suffix).\(type.fileExtension)"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(fileName)
    }

    func saveFile(from data: Data, name: String, type: FileType) throws {
        let fileURL = getFileURL(name: name, type: type)
        if fileManager.fileExists(atPath: fileURL.path) {
            try? fileManager.removeItem(at: fileURL)
        }
        try data.write(to: fileURL)
    }

    func loadFile(name: String, type: FileType) throws -> Data {
        let fileURL = getFileURL(name: name, type: type)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw NSError(
                domain: "DefaultFileService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File not found"]
            )
        }
        return try Data(contentsOf: fileURL)
    }
}
