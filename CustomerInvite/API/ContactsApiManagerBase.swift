//
//  ContactsApiManagerBase.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 01/04/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

final class ContactsApiManagerBase: ContactsApiManager {

    private struct Constants {

        static let downloadUrlString = "https://s3.amazonaws.com/intercom-take-home-test/customers.txt"

    }

    // MARK: - Public methods

    func downloadTxtAsString(completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: Constants.downloadUrlString) else { return }
        DataManager.download(from: url) { (localUrl, response, error) in
            if error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let localUrl = localUrl,
                let dataString = try? String(contentsOf: localUrl) {
                completion(dataString, nil)
            } else {
                completion(nil, error)
            }
        }
    }

}
