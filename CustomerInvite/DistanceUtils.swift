//
//  DistanceUtils.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

typealias Coordinates = (latitude: Double, longitude: Double)

protocol DistanceUtils:AnyObject {

    func distance(form location: Coordinates) -> Double

}

final class DistanceUtilsBase: DistanceUtils {

    private struct Constants {

        static let dublinOfficeCoordinates = Coordinates(53.339428, -6.257664)
        static let earthRadius: Double = 6371

    }

    // MARK: - Singleton instance

    let instance: DistanceUtils = DistanceUtilsBase()

    private init() {}

    // MARK: - Public methods

    func distance(form location: Coordinates) -> Double {
        calculateGreatCircleDistance1(from: Constants.dublinOfficeCoordinates, to: location)
    }

    // MARK: - Private methods (not exposed)

    func calculateGreatCircleDistance1(from origin: Coordinates, to destination: Coordinates) -> Double {
        let earthRadius: Double = 6371
        let pOrigin = origin.latitude.toRads()
        let pDestination = destination.latitude.toRads()
        let deltaP = (destination.latitude - origin.latitude).toRads()
        let deltaL = (destination.longitude - origin.longitude).toRads()
        let innerSqrt = sin(deltaP / 2) * sin(deltaP / 2) + cos(pOrigin) * cos(pDestination) * sin(deltaL / 2) * sin(deltaL / 2)
        let centralAngle = 2 * atan2(sqrt(innerSqrt), sqrt(1 - innerSqrt))
        return earthRadius * centralAngle
    }

}
