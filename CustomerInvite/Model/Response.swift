//
//  Response.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

struct Response: Codable {

    let userId: Int
    let name: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case latitude
        case longitude
    }

}
