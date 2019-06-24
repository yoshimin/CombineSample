//
//  Location.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation

struct Location: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

struct Prefectures: Codable {
    let prefectures: [Location]
}
