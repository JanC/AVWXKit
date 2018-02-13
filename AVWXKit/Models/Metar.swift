//
//  Metar.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation

struct Metar: Decodable {
    
    enum FlightRules: String, Decodable {
        case vfr = "VFR"
        case ifr = "IFR"
    }
    
    let rawReport: String
    let remarks: String
    let altimeter: String
    let dewPoint: String
    let flightRules: FlightRules
    let visibility: String
    let windDirection: String
    let windGust: String
    let windSpeed: String
    let windVariableDirection: [String]
    
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
