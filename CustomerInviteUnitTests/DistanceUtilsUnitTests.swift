//
//  DistanceUtilsUnitTests.swift
//  CustomerInviteUnitTests
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import XCTest
@testable import Customer_Invite

final class DistanceUtilsUnitTests: XCTestCase {

    private let origin = Coordinates(53.339428, -6.257664)
    private let destination = Coordinates(52.986375, -6.043701)

    // MARK: - Test methods

    func testDistance() {
        XCTAssertEqual(Distance.instance.distance(from: origin, to: destination), 41.76878319430922)
    }

}
