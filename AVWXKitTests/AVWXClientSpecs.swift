//
//  AVWXClientSpecs.swift
//  AVWXKitTests
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

@testable import AVWXKit
import Foundation
import Nimble
import OHHTTPStubs
import Quick

class AVWXClientSpecs: QuickSpec {
    
    override func spec() {
        describe("getting metar") {
            
            let sut = AVWXClient(token: "")
            
            var metar: Metar?
            var error: Error?
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            beforeEach {
                metar = nil
            }
            
            context("given a valid json response") {
                
                beforeEach {
                    stub(condition: isHost(sut.baseURL.host!)) { _ in
                        let stubPath = OHPathForFile("metar-response-valid.json", type(of: self))
                        return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
                    }
                    
                    sut.fetchMetar(forIcao: "KSBP") { result in
                        switch result {
                        case .success(let resultMetar):
                            metar = resultMetar
                        case .failure(let resultError):
                            error = resultError
                        }
                    }
                }
                it("completes without an error") {
                    expect(error).toEventually(beNil())
                }
                it("completes with a result") {
                    expect(metar).toNotEventually(beNil())
                }
            }
            
            context("given an invalid json response") {
                beforeEach {
                    stub(condition: isHost(sut.baseURL.host!)) { _ in
                        return OHHTTPStubsResponse(jsonObject: [ "foo": "bar"], statusCode: 200, headers: nil)
                    }
                    
                    sut.fetchMetar(forIcao: "KSBP") { result in
                        switch result {
                        case .success(let resultMetar):
                            metar = resultMetar
                        case .failure(let resultError):
                            error = resultError
                        }
                    }
                }
                it("completes with an error") {
                    expect(error).toNotEventually(beNil())
                }
                it("completes without an result") {
                    expect(metar).toEventually(beNil())
                }
            }
            
            context("given an 404 http code") {
                beforeEach {
                    stub(condition: isHost(sut.baseURL.host!)) { _ in
                        return OHHTTPStubsResponse(jsonObject: [ "foo": "bar"], statusCode: 404, headers: nil)
                    }
                    sut.fetchMetar(forIcao: "KSBP") { result in
                        switch result {
                        case .success(let resultMetar):
                            metar = resultMetar
                        case .failure(let resultError):
                            error = resultError
                        }
                    }
                }
                it("completes with an error") {
                    expect(error).toNotEventually(beNil())
                }
                
                it("completes with a correct http error") {
                    expect(error).toNotEventually(beNil())
                }
                it("completes without an result") {
                    expect(metar).toEventually(beNil())
                }
            }
        }
    }
}
