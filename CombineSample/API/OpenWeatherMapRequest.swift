//
//  OpenWeatherMapRequest.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/20.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import APIKit

protocol OpenWeatherMapRequest: Request {

}

extension OpenWeatherMapRequest {
    var appId: String {
        return "fafe2d5de9634e118884519f2148ba19"
    }

    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
}

extension OpenWeatherMapRequest where Self.Response: Swift.Decodable {
    var dataParser: DataParser {
        return PlainDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        guard let data = object as? Data,
            let response = try? decoder.decode(Self.Response.self, from: data) else {
                throw ResponseError.unexpectedObject(object)
        }
        return response
    }
}
