//
//  Endpoint.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 20.11.19.
//  Copyright © 2019 AeroNav. All rights reserved.
//

import CoreLocation
import Foundation

enum Endpoint {

    case metar(String, MetarOptions)
    case metarCoordintes(CLLocationCoordinate2D, MetarOptions)
    case taf(String)

    func url(baseURL: URL) -> URL {
        switch self {
        case let .metar(icao, options):
            var fullUrl = baseURL.appendingPathComponent("metar/\(icao)")
            fullUrl = Endpoint.addOptions(options: options, to: fullUrl)
            return fullUrl

        case let .metarCoordintes(coordinates, options):
            let formattedLat = String(format: "%0.3f", coordinates.latitude)
            let formattedLong = String(format: "%0.3f", coordinates.longitude)
            var fullUrl = baseURL.appendingPathComponent("metar/\(formattedLat),\(formattedLong)")
            fullUrl = Endpoint.addOptions(options: options, to: fullUrl)
            return fullUrl

        case .taf(let icao):
            return baseURL.appendingPathComponent("taf/\(icao)")
        }
    }
    private static func addOptions(options: MetarOptions, to url: URL) -> URL {
        var resultUrl = url
        if
            let optionValues = options.string(),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            components.queryItems =  [URLQueryItem(name: "options", value: optionValues)]
            if let url = components.url {
                resultUrl = url
            }
        }
        return resultUrl
    }
}
