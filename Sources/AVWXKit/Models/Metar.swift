//
//  Metar.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import CommonCrypto
import Foundation

public struct Metar: Decodable {
    public enum FlightRules: String, Decodable {
        case vfr = "VFR"
        case mfr = "MVFR"
        case ifr = "IFR"
        case lifr = "LIFR"
    }
    
    public struct Info: Decodable {
        public let name: String
        public let city: String
        public let icao: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case city
            case icao
        }
    }

    public struct Value: Decodable {
        public let repr: String
        public let spoken: String
        // nil when r.g. 
        public let value: Double?
    }

    public typealias Altimeter = Value
    public typealias Dewpoint = Value
    public typealias Visibility = Value
    public typealias WindDirection = Value
    public typealias WindSpeed = Value
    public typealias WindGust = Value
    
    public let rawReport: String
    public let station: String
    public let remarks: String
    public let altimeter: Altimeter
    public let dewPoint: Dewpoint
    public let flightRules: FlightRules
    public let visibility: Visibility
    public let windDirection: WindDirection?
    public let windGust: WindGust?
    public let windSpeed: WindSpeed?
    public let windVariableDirection: [WindDirection]

    public var date: Date {
        return metarDate.date
    }
    let metarDate: MetarDate
    
    /// if requested with the "speech" option
    public let speech: String?
    
    /// if requested with the "info" option
    public let info: Info?

    // if requested with the "translate" option
    public let translations: Translations?
    
    enum CodingKeys: String, CodingKey {
        case rawReport      = "raw"
        case station        = "station"
        case altimeter      = "altimeter"
        case dewPoint       = "dewpoint"
        case flightRules    = "flight_rules"
        case remarks        = "remarks"
        case visibility     = "visibility"
        case windDirection  = "wind_direction"
        case windGust       = "wind_gust"
        case windSpeed      = "wind_speed"
        case windVariableDirection = "wind_variable_direction"
        case speech         = "speech"
        case info           = "info"
        case metarDate      = "time"
        case translations   = "translate"
    }
}

// MARK: - Helpers
public extension Metar {
    var minutesOld: Int {
        let now = Date()
        let oldSec = now.timeIntervalSince(date) / 60
        return Int(oldSec)
    }
}
