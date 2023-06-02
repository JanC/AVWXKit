//
//  MetarDate.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 21.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation

// encapsluates the metar string date in order to faciliate the JSON parsing
struct MetarDate: Decodable {
    let date: Date
    enum CodingKeys: String, CodingKey {
        // "121756Z",
        case repr = "repr"
        // "2019-04-12T17:56:00Z"
        case dt = "dt"
    }
    init(from decoder: Decoder) throws {
        // The metar time has a format 'ddHHmmZ' (e.g 130756Z)
        // So we need to append the current year and month (yyyy-MM) in order to parse the entire date back
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .dt)
    }
}
