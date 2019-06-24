//
//  LocationsRepository.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine
import APIKit

protocol CurrentWeatherRepository {
    func fetch(latitude: Double, longitude: Double) -> AnyPublisher<CurrentWeather, Error>
}

class CurrentWeatherRepositoryImpl: CurrentWeatherRepository {
    func fetch(latitude: Double, longitude: Double) -> AnyPublisher<CurrentWeather, Error> {
        return Publishers.Future { promise in
            let request = CurrentWeatherRequest(latitude: latitude, longitude: longitude)
            Session.send(request) { result in
                switch result {
                case .success(let weather):
                    promise(.success(weather))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


