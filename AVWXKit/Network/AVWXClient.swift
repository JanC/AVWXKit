//
//  AVWXClient.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation
import CoreLocation

public struct AVWXClient {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let baseURL: URL
    
    
    public enum ClientError: Error {
        case invalidResponseCode(Int)
        case parsing(Error)
        case network(Error)
    }
    

    public struct MetarOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let speech       = MetarOptions(rawValue: 1 << 0)
        public static let info         = MetarOptions(rawValue: 1 << 1)
        public static let translate    = MetarOptions(rawValue: 1 << 2)
        
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
    
    public enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum Endpoint {
        
        case metar(String, MetarOptions)
        case metarCoordintes(CLLocationCoordinate2D, MetarOptions)
        case taf(String)
        
        func url(baseURL: URL) -> URL {
            switch self {
            case .metar(let icao, let options):
                var fullUrl = baseURL.appendingPathComponent("metar/\(icao)")
                fullUrl = Endpoint.addOptions(options: options, to: fullUrl)
                return fullUrl
                
            case .metarCoordintes(let coordinates, let options):
                let formattedLat = String(format: "%0.3f", coordinates.latitude)
                let formattedLong = String(format: "%0.3f", coordinates.longitude)
                var fullUrl = baseURL.appendingPathComponent("metar/\(formattedLat),\(formattedLong)")
                fullUrl = Endpoint.addOptions(options: options, to: fullUrl)
                return fullUrl

                
            case .taf(let icao):
                return baseURL.appendingPathComponent("taf/\(icao)")
            }
        }
        private static func addOptions(options: MetarOptions, to url: URL) -> URL {
            var resultUrl = url
            if
                let optionValues = options.string(),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            {
                components.queryItems =  [URLQueryItem(name: "options", value: optionValues)]
                if let url = components.url {
                    resultUrl = url
                }
            }
            return resultUrl
        }
    }
    
    public init(baseURL: URL = URL(string: "https://avwx.rest/api/")!) {
        self.baseURL = baseURL
    }
    
    public func fetchMetar(forIcao icao: String, options: MetarOptions = [], completion: @escaping (Result<Metar>) -> Void ) {
        let endpoint = Endpoint.metar(icao, options)
        
        fetch(endpoint: endpoint) { (result: Result<Metar>) in
            print("METAR done: \(result)")
            completion(result)
        }
    }
    
    public func fetchMetar(at coordinates: CLLocationCoordinate2D, options: MetarOptions = [], completion: @escaping (Result<Metar>) -> Void ) {
        let endpoint = Endpoint.metarCoordintes(coordinates, options)
        fetch(endpoint: endpoint) { (result: Result<Metar>) in
            print("METAR done: \(result)")
            completion(result)
        }
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void ) {
        let url = endpoint.url(baseURL: baseURL)
        debugPrint("METAR GET \(url.absoluteString)")
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                completion(.failure(ClientError.invalidResponseCode(httpResponse.statusCode)))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(Result.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
