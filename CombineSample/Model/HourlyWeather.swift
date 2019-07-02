//
//  HourlyWeather.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/07/02.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation

struct DailyWeather {
    let date: String
    let list: [HourlyWeather]
}

struct HourlyWeather {
    let hour: Int
    let weather: Weather
    let temp: Double
}
