//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import Foundation

public struct Translations: Codable {
    
    public let altimeter: String
    public let clouds: String
    public let dewpoint: String
    public let other: String
    public let remarks: [String: String]
    public let temperature: String
    public let visibility: String
    public let wind: String

    private enum CodingKeys: String, CodingKey {
        case altimeter = "altimeter"
        case clouds = "clouds"
        case dewpoint = "dewpoint"
        case other = "other"
        case remarks = "remarks"
        case temperature = "temperature"
        case visibility = "visibility"
        case wind = "wind"
    }
}
