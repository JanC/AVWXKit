//
//  AVWXClient.swift
//  AVWXKit
//
//  Created by Jan Chaloupecky on 13.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import CoreLocation
import Foundation

public struct AVWXClient {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let baseURL: URL
    let token: String
    
    public enum ClientError: Error {
        case invalidResponseCode(Int)
        case parsing(Error)
        case network(Error)
        case noData
    }

    public init(baseURL: URL = URL(string: "https://avwx.rest/api/")!, token: String = "") {
        self.baseURL = baseURL
        self.token = token
    }
    
    public func fetchMetar(at icao: String, options: MetarOptions = [], completion: @escaping (Result<Metar, Error>) -> Void ) {
        let endpoint = Endpoint.metar(icao, options)
            fetch(endpoint: endpoint, completion: completion)
    }
    
    public func fetchMetar(at coordinates: CLLocationCoordinate2D, options: MetarOptions = [], completion: @escaping (Result<Metar, Error>) -> Void ) {
        let endpoint = Endpoint.metarCoordintes(coordinates, options)
        fetch(endpoint: endpoint, completion: completion)
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void ) {
        let url = endpoint.url(baseURL: baseURL)
        debugPrint("GET \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                completion(.failure(ClientError.invalidResponseCode(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(ClientError.noData))
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(Result.success(result))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
