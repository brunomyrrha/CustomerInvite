//
//  DistanceUtils.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 31/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation

typealias Coordinates = (latitude: Double, longitude: Double)

final class Distance {

    private struct Constants {

        static let earthRadius: Double = 6371.0088

    }

    // MARK: - Singleton instance

    static let instance = Distance()

    private init() {}

    // MARK: - Public methods

    func distance(from origin: Coordinates, to destination: Coordinates) -> Double {
        let oLat = origin.latitude.toRads()
        let oLong = origin.longitude.toRads()
        let dLat = destination.latitude.toRads()
        let dLong = destination.longitude.toRads()
        let angle = acos(sin(oLat) * sin(dLat) + cos(oLat) * cos(dLat) * cos(abs(oLong - dLong)))
        return Constants.earthRadius * angle
    }

}
