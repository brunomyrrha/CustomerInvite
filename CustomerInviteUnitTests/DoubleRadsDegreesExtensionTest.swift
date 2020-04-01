//
//  DoubleRadsDegreesExtensionTest.swift
//  CustomerInviteUnitTests
//
//  Created by Bruno Diniz on 30/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import XCTest
@testable import Customer_Invite

final class DoubleRadsDegreesExtensionTest: XCTestCase {

    // MARK: - Test methods

    func testConversionDegreesToRads() {
        var degrees: Double = 0
        XCTAssertEqual(degrees.toRads(), 0)
        degrees = 45
        XCTAssertEqual(degrees.toRads(), .pi/4)
        degrees = 90
        XCTAssertEqual(degrees.toRads(), .pi/2)
        degrees = 180
        XCTAssertEqual(degrees.toRads(), .pi)
        degrees = 360
        XCTAssertEqual(degrees.toRads(), 2 * .pi)
    }

    func testConversionRadsToDegrees() {
        var radians: Double = 0
        XCTAssertEqual(radians.toDegrees(), 0)
        radians = .pi/4
        XCTAssertEqual(radians.toDegrees(), 45)
        radians = .pi/2
        XCTAssertEqual(radians.toDegrees(), 90)
        radians = .pi
        XCTAssertEqual(radians.toDegrees(), 180)
        radians = 2 * .pi
        XCTAssertEqual(radians.toDegrees(), 360)
    }

}
