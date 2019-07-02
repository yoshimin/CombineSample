//
//  MainViewInteractor.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine

protocol MainViewInteractor {
    var prefectureListRepository: PrefectureListRepository { get }
    var currentWeatherRepository: CurrentWeatherRepository { get }

    func fetch() -> AnyPublisher<[PrefectureWeather], Error>
}

class MainViewInteractorImpl: MainViewInteractor {
    var prefectureListRepository: PrefectureListRepository
    var currentWeatherRepository: CurrentWeatherRepository

    init(prefectureListRepository: PrefectureListRepository,
         currentWeatherRepository: CurrentWeatherRepository) {
        self.prefectureListRepository = prefectureListRepository
        self.currentWeatherRepository = currentWeatherRepository
    }

    func fetch() -> AnyPublisher<[PrefectureWeather], Error> {
        prefectureListRepository.fetch()
            .flatMap{ [weak self] locations -> AnyPublisher<[PrefectureWeather], Error> in
                let publishers = locations.compactMap{ location in
                    return self?.currentWeatherRepository.fetch(latitude: location.latitude, longitude: location.longitude)
                        .map{ weather -> PrefectureWeather in
                            return PrefectureWeather(id: weather.id, name: location.name, code: weather.weather.first!.main, icon: weather.weather.first!.icon, temp: weather.main.temp)
                        }
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
