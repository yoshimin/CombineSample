//
//  CurrentWeatherRequest.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/20.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import APIKit

struct CurrentWeatherRequest: OpenWeatherMapRequest {
    typealias Response = CurrentWeather

    var method: HTTPMethod = .get
    var path: String = "/data/2.5/weather"

    private let latitude: Double
    private let longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    var queryParameters: [String : Any]? {
        return ["APPID": appId, "units": "metric", "lat": latitude, "lon": longitude]
    }
}
