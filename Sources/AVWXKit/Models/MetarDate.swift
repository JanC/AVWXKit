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
        // todo
//        "repr": "121756Z",
//        "dt": "2019-04-12T17:56:00Z"
        case time = "repr"
    }
    public init(from decoder: Decoder) throws {
        // The metar time has a format 'ddHHmmZ' (e.g 130756Z)
        // So we need to append the current year and month (yyyy-MM) in order to parse the entire date back
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metarString = try container.decode(String.self, forKey: .time)
        
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM"
        
        let thisMonth = formatter.string(from: now)
        // yy-MM-ddHHmmZ
        let metarFullDateString = thisMonth + "-" + metarString
        
        formatter.dateFormat = "yy-MM-ddHHmmZ"
        date = formatter.date(from: metarFullDateString)!
    }
}
