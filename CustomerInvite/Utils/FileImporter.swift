//
//  FileImporter.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation


typealias DownloadCompletion = (Any?, URLResponse?, Error?) -> Void

final class FileManager {

    class func download(url: URL, completion: @escaping  DownloadCompletion) {
        let task = URLSession.shared.downloadTask(with: url) { local, response, error in
            completion(local, response, error)
        }
        task.resume()
    }

}
