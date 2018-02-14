//
//  AVWXClient.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation

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
        case taf(String)
        
        func url(baseURL: URL) -> URL {
            switch self {
            case .metar(let icao, let options):
                
                var fullUrl = baseURL.appendingPathComponent("metar/\(icao)")
                
                if
                    let optionValues = options.string(),
                    var components = URLComponents(url: fullUrl, resolvingAgainstBaseURL: false)
                {
                    components.queryItems =  [URLQueryItem(name: "options", value: optionValues)]
                    if let url = components.url {
                        fullUrl = url
                    }
                }
                return fullUrl
                
                
            case .taf(let icao):
                return baseURL.appendingPathComponent("taf/\(icao)")
            }
        }
    }
    
    public init(baseURL: URL = URL(string: "https://avwx.rest/api/")!) {
        self.baseURL = baseURL
    }
    
    public func fetchMetar(forIcao icao: String, options: MetarOptions = [], completion: @escaping (Result<Metar>) -> () ) {
        
        let endpoint = Endpoint.metar(icao, options)
        
        fetch(endpoint: endpoint) { (result: Result<Metar>) in
            completion(result)
        }
    }
    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> () ) {
        let task = session.dataTask(with: endpoint.url(baseURL: baseURL)) { (data, response, error) in
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
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
