//
//  ForecastRepository.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/28.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine
import APIKit

protocol ForecastRepository {
    func fetch(id: Int) -> AnyPublisher<Forecast, Error>
}

class ForecastRepositoryImpl: ForecastRepository {
    func fetch(id: Int) -> AnyPublisher<Forecast, Error> {
        return Publishers.Future { promise in
            let request = ForecastRequest(id: id)
            Session.send(request) { result in
                switch result {
                case .success(let forecast):
                    promise(.success(forecast))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
            }
            .eraseToAnyPublisher()
    }
}
