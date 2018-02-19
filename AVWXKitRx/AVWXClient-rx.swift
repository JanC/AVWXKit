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

extension AVWXClient {
    
    public func fetchMetar(forIcao icao: String, options: MetarOptions = []) -> Observable<Metar> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchMetar(forIcao: icao, options: options, completion: { (result) in
                switch result {
                case .success(let metar):
                    observer.onNext(metar)
                    break
                case .failure(let error):
                    observer.onError(error)
                    break
                }
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
