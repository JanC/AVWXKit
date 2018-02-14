//
//  Metar.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation

public struct Metar: Decodable {
    
    public enum FlightRules: String, Decodable {
        case vfr = "VFR"
        case ifr = "IFR"
    }
    
    public let rawReport: String
    public let remarks: String
    public let altimeter: String
    public let dewPoint: String
    public let flightRules: FlightRules
    public let visibility: String
    public let windDirection: String
    public let windGust: String
    public let windSpeed: String
    public let windVariableDirection: [String]
    
    enum CodingKeys: String, CodingKey {
        case rawReport      = "Raw-Report"
        case altimeter      = "Altimeter"
        case dewPoint       = "Dewpoint"
        case flightRules    = "Flight-Rules"
        case remarks        = "Remarks"
        case visibility     = "Visibility"
        case windDirection  = "Wind-Direction"
        case windGust       = "Wind-Gust"
        case windSpeed      = "Wind-Speed"
        case windVariableDirection = "Wind-Variable-Dir"
        
    }
}
