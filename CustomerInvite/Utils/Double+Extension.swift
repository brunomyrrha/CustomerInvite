//
//  Double+Trigonometric.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

extension Double {

    func toRads() -> Self {
        self * .pi / 180
    }

    func toDegrees() -> Self {
        self * 180 / .pi
    }

}
