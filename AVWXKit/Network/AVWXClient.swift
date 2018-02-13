//
//  AVWXClient.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation

struct AVWXClient {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let baseURL: URL
    
    
    
    public enum AVWXClientError: Error {
        case invalidResponseCode(Int)
        case parsing(Error)
        case network(Error)
    }
    
    public enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum Endpoint {
        case metar(String)
        case taf(String)
        
        func url(baseURL: URL) -> URL {
            switch self {
            case .metar(let icao):
                return baseURL.appendingPathComponent("metar/\(icao)")
            case .taf(let icao):
                return baseURL.appendingPathComponent("taf/\(icao)")
            }
        }
    }
    
    public init(baseURL: URL = URL(string: "https://avwx.rest/api/")!) {
        self.baseURL = baseURL
    }
    
    public func fetchMetar(forIcao icao: String, completion: @escaping (Result<Metar>) -> () ) {
        fetch(for: icao) { (result: Result<Metar>) in
            completion(result)
        }
    }
    public func fetch<T: Decodable>(for icao: String, completion: @escaping (Result<T>) -> () ) {
        let task = session.dataTask(with: Endpoint.metar(icao).url(baseURL: baseURL)) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                completion(.failure(AVWXClientError.invalidResponseCode(httpResponse.statusCode)))
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
