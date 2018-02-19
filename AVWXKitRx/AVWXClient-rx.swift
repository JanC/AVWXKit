//
//  AVWXClient-rx.swift
//  AVWXKitRx
//
//  Created by Jan Chaloupecky on 19.02.18.
//  Copyright © 2018 AeroNav. All rights reserved.
//

import Foundation
import AVWXKit
import RxSwift
import CoreLocation

extension AVWXClient {
    
    public func fetchMetar(forIcao icao: String, options: MetarOptions = []) -> Single<Metar> {
       
        return Single.create { (observer) -> Disposable in
            
            self.fetchMetar(forIcao: icao, options: options, completion: { (result) in
                switch result {
                case .success(let metar):
                    observer(.success(metar))
                    break
                case .failure(let error):
                    observer(.error(error))
                    break
                }
            })
            return Disposables.create()
        }
    }
    
    public func fetchMetar(at coordinates: CLLocationCoordinate2D, options: MetarOptions = []) -> Single<Metar> {
        
        return Single.create { (observer) -> Disposable in

            self.fetchMetar(at: coordinates, options: options, completion: { (result) in
                switch result {
                case .success(let metar):
                    observer(.success(metar))
                    break
                case .failure(let error):
                    observer(.error(error))
                    break
                }
            })
            return Disposables.create()
        }
    }
}
