//
//  ForecastRequest.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/28.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import APIKit

struct ForecastRequest: OpenWeatherMapRequest {
    typealias Response = Forecast

    var method: HTTPMethod = .get
    var path: String = "/data/2.5/forecast"

    private let id: Int
    init(id: Int) {
        self.id = id
    }

    var queryParameters: [String : Any]? {
        return ["APPID": appId, "units": "metric", "id": id]
    }
}
