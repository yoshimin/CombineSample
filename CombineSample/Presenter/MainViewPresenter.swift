//
//  MainViewPresenter.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol MainViewPresenterInputs {
    var fetch: PassthroughSubject<Void,Never> { get }
}

protocol MainViewPresenterOutputs {
    var prefectures: [PrefectureWeather] { get }
    var didChange: PassthroughSubject<Void, Never> { get }
}

protocol MainViewPresenter {
    var inputs: MainViewPresenterInputs { get }
    var outputs: MainViewPresenterOutputs { get }
    var interactor: MainViewInteractor { get }
}

final class MainViewPresenterImpl: MainViewPresenter {
    var inputs: MainViewPresenterInputs { return self }
    var outputs: MainViewPresenterOutputs { return self }

    let interactor: MainViewInteractor
    let fetch = PassthroughSubject<Void, Never>()
    let didChange = PassthroughSubject<Void, Never>()

    private(set) var prefectures: [PrefectureWeather] = [] {
        didSet {
            didChange.send(())
        }
    }
    private lazy var updatePrefectures = Subscribers.Assign(object: self, keyPath: \.prefectures)

    private let prefecturesSubject = PassthroughSubject<[PrefectureWeather], Never>()

    init(interactor: MainViewInteractor) {
        self.interactor = interactor

        let _ = fetch
            .flatMap{ _ in
                interactor.fetch()
                    .catch { error -> AnyPublisher<[PrefectureWeather], Never> in
                        return Publishers.Empty<[PrefectureWeather], Never>().eraseToAnyPublisher()
                }
            }
            .receive(subscriber: updatePrefectures)
    }
}

extension MainViewPresenterImpl: MainViewPresenterInputs, MainViewPresenterOutputs {}
