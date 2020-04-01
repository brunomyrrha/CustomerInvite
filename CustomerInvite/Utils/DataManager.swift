//
//  DataManager.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation


typealias DownloadCompletion = (URL?, URLResponse?, Error?) -> Void

final class DataManager {

    class func download(from url: URL, completion: @escaping  DownloadCompletion) {
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }

    class func export(_ data: [Contact]) -> URL? {
        guard let encodedData = try? JSONEncoder().encode(data) else { return nil }
        let filename = "export.txt"
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try encodedData.write(to: temp)
            return temp
        } catch {
            return nil
        }
    }

}
