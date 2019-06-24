//
//  MainViewBuilder.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/20.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

struct MainViewBuilder {
    static func build() -> MainViewController {
        let interactor = MainViewInteractorImpl(prefectureListRepository: PrefectureListRepositoryImpl(),
                                                currentWeatherRepository: CurrentWeatherRepositoryImpl())
        let presenter = MainViewPresenterImpl(interactor: interactor)
        let viewController = StoryboardScene.MainView.initialScene.instantiate()
        viewController.presenter = presenter
        return viewController
    }
}
