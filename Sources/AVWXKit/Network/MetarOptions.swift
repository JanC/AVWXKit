//
//  MetarOptions.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 20.11.19.
//  Copyright © 2019 AeroNav. All rights reserved.
//

import Foundation

public struct MetarOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let speech = MetarOptions(rawValue: 1 << 0)
    public static let info = MetarOptions(rawValue: 1 << 1)
    public static let translate = MetarOptions(rawValue: 1 << 2)

    func string() -> String? {
        var result = [String]()
        if self.isEmpty {
            return nil
        }
        if self.contains(.info) {
            result.append("info")
        }
        if self.contains(.translate) {
            result.append("translate")
        }
        if self.contains(.speech) {
            result.append("speech")
        }

        return result.joined(separator: ",")
    }
}
