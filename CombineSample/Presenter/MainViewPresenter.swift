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
    var showDetail: PassthroughSubject<Int,Never> { get }
}

protocol MainViewPresenterOutputs {
    var prefectures: [PrefectureWeather] { get }
    var didChange: PassthroughSubject<Void, Never> { get }
}

protocol MainViewPresenter {
    var inputs: MainViewPresenterInputs { get }
    var outputs: MainViewPresenterOutputs { get }
    var interactor: MainViewInteractor { get }
    var wireframe: MainViewWireframe { get }
}

final class MainViewPresenterImpl: MainViewPresenter {
    var inputs: MainViewPresenterInputs { return self }
    var outputs: MainViewPresenterOutputs { return self }

    let interactor: MainViewInteractor
    let wireframe: MainViewWireframe
    let fetch = PassthroughSubject<Void, Never>()
    let showDetail = PassthroughSubject<Int, Never>()
    let didChange = PassthroughSubject<Void, Never>()

    private(set) var prefectures: [PrefectureWeather] = [] {
        didSet {
            didChange.send(())
        }
    }
    private lazy var updatePrefectures = Subscribers.Assign(object: self, keyPath: \.prefectures)

    init(interactor: MainViewInteractor, wireframe: MainViewWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe

        let _ = fetch
            .flatMap{ _ in
                interactor.fetch()
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .receive(subscriber: updatePrefectures)

        let _ = showDetail
            .sink { id in
                wireframe.showDetail(cityId: id)
        }
    }
}

extension MainViewPresenterImpl: MainViewPresenterInputs, MainViewPresenterOutputs {}
