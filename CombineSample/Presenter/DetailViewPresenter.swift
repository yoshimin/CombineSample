//
//  DetailViewPresenter.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/28.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

protocol DetailViewPresenterInputs {
    var fetch: PassthroughSubject<Void,Never> { get }
    var dismiss: PassthroughSubject<Void,Never> { get }
}

protocol DetailViewPresenterOutputs {
    var weatherList: [DailyWeather] { get }
    var errorMessage: String? { get }
    var didChange: PassthroughSubject<Void, Never> { get }
}

protocol DetailViewPresenter {
    var inputs: DetailViewPresenterInputs { get }
    var outputs: DetailViewPresenterOutputs { get }
    var interactor: DetailViewInteractor { get }
    var wireframe: DetailViewWireframe { get }
}

final class DetailViewPresenterImpl: DetailViewPresenter {
    struct State {
        var weatherList: [DailyWeather] = []
        var errorMessage: String?
    }

    var inputs: DetailViewPresenterInputs { return self }
    var outputs: DetailViewPresenterOutputs { return self }

    let interactor: DetailViewInteractor
    let wireframe: DetailViewWireframe

    let fetch = PassthroughSubject<Void,Never>()
    let dismiss = PassthroughSubject<Void,Never>()
    let didChange = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    var weatherList: [DailyWeather] {
        return state.weatherList
    }
    var errorMessage: String? {
        return state.errorMessage
    }

    private var state: State = State() {
        didSet {
            didChange.send(())
        }
    }

    private lazy var updateList = Subscribers.Assign(object: self, keyPath: \.state.weatherList)
    private lazy var updateErrorMessage = Subscribers.Assign(object: self, keyPath: \.state.errorMessage)

    init(interactor: DetailViewInteractor, wireframe: DetailViewWireframe, cityId: Int) {
        self.interactor = interactor
        self.wireframe = wireframe

        let _ = fetch
            .flatMap { _ in
                interactor.fetch(id: cityId)
                    .catch { [weak self] error -> Publishers.Empty<[DailyWeather], Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(subscriber: updateList)

        let _ = errorSubject
            .map{_ in "情報の取得に失敗しました"}
            .eraseToAnyPublisher()
            .receive(subscriber: updateErrorMessage)

        let _ = dismiss
            .sink { _ in
            wireframe.dismiss()
        }
    }

}

extension DetailViewPresenterImpl: DetailViewPresenterInputs, DetailViewPresenterOutputs {}
