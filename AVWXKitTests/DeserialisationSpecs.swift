//
//  DeserialisationSpecs.swift
//  AVWXKitTests
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Quick
import Nimble
@testable import AVWXKit

import Foundation

class DeserialisationSpecs: QuickSpec {
    
    override func spec() {
        
        let decoder = JSONDecoder()
        
        describe("metar parsing") {
            
            context("given a valid metar") {
                var metar: Metar?
                beforeEach {
                    let data = try! Data(contentsOf:Bundle(for: type(of: self)).url(forResource: "metar-response-valid", withExtension: "json")!)
                    do {
                        metar = try decoder.decode(Metar.self, from: data)
                    } catch {
                        print(error)
                    }
                    
                }
                
                it("parses the raw report") {
                    expect(metar?.rawReport).to(equal("KSBP 130756Z 00000KT 10SM BKN095 08/04 A2995 RMK AO2 SLP143 T00780039 401610039"))
                }
                
                it("parses the altimeter") {
                    expect(metar?.altimeter).to(equal("2995"))
                }
                
                it("parses the date") {
                    expect(metar?.metarDate).notTo(beNil())
                }
                
                it("parses the dew point") {
                    expect(metar?.dewPoint).to(equal("04"))
                }
                
                it("parses the flight rules") {
                    expect(metar?.flightRules).to(equal(.vfr))
                }
            }
        }
    }
}
