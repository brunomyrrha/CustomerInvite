//
//  FileManager.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation


typealias DownloadCompletion = (URL?, URLResponse?, Error?) -> Void

final class FileManager {

    class func download(from url: URL, completion: @escaping  DownloadCompletion) {
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }

    class func exportTo() {
        
    }

}
