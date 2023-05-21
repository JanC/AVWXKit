//
//  This file is part of AeroNav SDK.
//  See the file LICENSE.txt for copying permission.
//

import Foundation

public struct Translations: Codable {
    public let altimeter: String
    public let clouds: String
    public let dewpoint: String
    public let wxCodes: String
    public let remarks: [String: String]
    public let temperature: String
    public let visibility: String
    public let wind: String

    private enum CodingKeys: String, CodingKey {
        case altimeter
        case clouds
        case dewpoint
        case wxCodes = "wx_codes"
        case remarks
        case temperature
        case visibility
        case wind
    }
}
