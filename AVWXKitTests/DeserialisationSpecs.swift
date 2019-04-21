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
                    let data = self.jsonData(forResource: "metar-response-valid")
                    do {
                        metar = try decoder.decode(Metar.self, from: data)
                    } catch {
                        XCTFail("Failed to parse: \(error)")
                    }
                    
                }
                
                it("parses the raw report") {
                    expect(metar?.rawReport).to(equal("KSBP 121656Z VRB05KT 10SM SCT031 15/07 A2993 RMK AO2 SLP136 T01500072"))
                }
                
                it("parses the altimeter") {
                    expect(metar?.altimeter.repr).to(equal("2993"))
                }
                
                it("parses the date") {
                    expect(metar?.metarDate.date.timeIntervalSince1970).to(equal(1555088160))
                }
                
                it("parses the dew point") {
                    expect(metar?.dewPoint.repr).to(equal("07"))
                }
                
                it("parses the flight rules") {
                    expect(metar?.flightRules).to(equal(.vfr))
                }
            }

            context("given a valid metar without wind") {
                var metar: Metar?
                beforeEach {
                    let data = self.jsonData(forResource: "metar-response-valid-no-wind")
                    do {
                        metar = try decoder.decode(Metar.self, from: data)
                    } catch {
                        XCTFail("Failed to parse: \(error)")
                    }
                }

                it("parses the metar") {
                    expect(metar?.rawReport).notTo(beNil())
                }
            }

            context("given a valid metar with translation") {
                var metar: Metar?
                beforeEach {
                    let data = self.jsonData(forResource: "metar-response-valid-translate")
                    do {
                        metar = try decoder.decode(Metar.self, from: data)
                    } catch {
                        XCTFail("Failed to parse: \(error)")
                    }

                }

                it("parses the traslations") {
                    expect(metar?.translations).notTo(beNil())
                }

                it("parses the altimeter") {
                    expect(metar?.translations?.altimeter).to(equal("29.83inHg (1010hPa)"))
                }
            }
        }
    }
}

extension XCTestCase {
    func jsonData(forResource fileName: String) -> Data {
        let data = try! Data(contentsOf:Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")!)
        return data
    }
}
