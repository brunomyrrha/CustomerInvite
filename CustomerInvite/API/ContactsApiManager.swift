//
//  ContactsApiManager.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 01/04/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

protocol ContactsApiManager: AnyObject {

    func downloadTxtAsString(completion: @escaping (String?, Error?) -> Void)

}
