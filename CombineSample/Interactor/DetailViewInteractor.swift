//
//  DetailViewInteractor.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/28.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine

protocol DetailViewInteractor {
    var forecastRepository: ForecastRepository { get }

    func fetch(id: Int) -> AnyPublisher<[DailyWeather], Error>
}

class DetailViewInteractorImpl: DetailViewInteractor {
    let forecastRepository: ForecastRepository

    init(forecastRepository: ForecastRepository) {
        self.forecastRepository = forecastRepository
    }

    func fetch(id: Int) -> AnyPublisher<[DailyWeather], Error> {
        return forecastRepository.fetch(id: id)
            .map { forcast -> [DailyWeather] in
                return Dictionary(grouping: forcast.list) { list -> String in
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyy/MM/dd"

                    return formatter.string(from: Date(timeIntervalSince1970: list.dt))
                    }
                    .reduce(into: [String:[List]]()) { (result, dict) in
                        result[dict.key] = dict.value.sorted { $0.dt < $1.dt }
                    }
                    .map { dict in
                        let list = dict.value.map { list -> HourlyWeather in
                            let hour = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: list.dt))
                            return HourlyWeather(hour: hour, weather: list.weather.first!, temp: list.main.temp)
                        }
                        return DailyWeather(date: dict.key, list: list)
                    }
                    .sorted{ $0.date < $1.date }
            }
            .eraseToAnyPublisher()
    }
}
