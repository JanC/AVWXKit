//
//  EndpointSpecs.swift
//  AVWXKitTests
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

@testable import AVWXKit
import CoreLocation
import Foundation
import Nimble
import Quick

class EndpointSpecs: QuickSpec {
    let baseURL = URL(string: "https://avwx.rest/api/")!
    override func spec() {
        describe("metar endpoint") {
            context("with icao") {
                var url: URL!
                beforeEach {
                    url = Endpoint.metar("KSBP", []).url(baseURL: self.baseURL)
                }

                it("returns a url with icao") {
                    expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP"))
                }
            }
            
            context("with coordinates") {
                var url: URL!
                beforeEach {
                    let coordinates = CLLocationCoordinate2D(latitude: 35.2371234, longitude: -120.6441234)
                    url = Endpoint.metarCoordintes(coordinates, []).url(baseURL: self.baseURL)
                }
                
                it("returns a url with icao") {
                    expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/35.237,-120.644"))
                }
            }
            
            context("with options") {
                context("info option") {
                    var url: URL!
                    beforeEach {
                        url = Endpoint.metar("KSBP", [.info]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=info"))
                    }
                }
                
                context("translate option") {
                    var url: URL!
                    beforeEach {
                        url = Endpoint.metar("KSBP", [.translate]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=translate"))
                    }
                }
                
                context("translate and info option") {
                    var url: URL!
                    beforeEach {
                        url = Endpoint.metar("KSBP", [.info, .translate]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=info,translate"))
                    }
                }
            }
        }
    }
}
