//
//  EndpointSpecs.swift
//  AVWXKitTests
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AVWXKit

class EndpointSpecs: QuickSpec {
    
    let baseURL = URL(string: "https://avwx.rest/api/")!
    override func spec() {
        
        fdescribe("metar endpoint") {
            context("with icao") {
                var url: URL!
                beforeEach {
                    url = AVWXClient.Endpoint.metar("KSBP", []).url(baseURL: self.baseURL)
                }

                it("returns a url with icao") {
                    expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP"))
                }
            }
            
            context("with options") {
                
                context("info option") {
                    var url: URL!
                    beforeEach {
                        url = AVWXClient.Endpoint.metar("KSBP", [.info]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=info"))
                    }
                }
                
                context("translate option") {
                    var url: URL!
                    beforeEach {
                        url = AVWXClient.Endpoint.metar("KSBP", [.translate]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=translate"))
                    }
                }
                
                context("translate and info option") {
                    var url: URL!
                    beforeEach {
                        url = AVWXClient.Endpoint.metar("KSBP", [.info, .translate]).url(baseURL: self.baseURL)
                    }
                    
                    it("returns a url with icao") {
                        expect(url.absoluteString).to(equal("https://avwx.rest/api/metar/KSBP?options=info,translate"))
                    }
                }
            }
        }
    }
}
