//
//  PrefectureListRepository.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/20.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine

protocol PrefectureListRepository {
    func fetch() -> AnyPublisher<[Location], Error>
}

class PrefectureListRepositoryImpl: PrefectureListRepository {
    func fetch() -> AnyPublisher<[Location], Error> {
        return Publishers.Future { promise in
            guard let path = Bundle.main.path(forResource: "prefectures", ofType: "json") else {
                assertionFailure("prefectures.json: No such file")
                return
            }
            let url = URL(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: url),
                let prefectures = try? JSONDecoder().decode(Prefectures.self, from: data) else {
                    promise(.success([]))
                    return
            }
            promise(.success(prefectures.prefectures))
        }
        .eraseToAnyPublisher()
    }
}
