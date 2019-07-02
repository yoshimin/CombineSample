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
        let viewController = StoryboardScene.MainView.initialScene.instantiate()
        let interactor = MainViewInteractorImpl(prefectureListRepository: PrefectureListRepositoryImpl(),
                                                currentWeatherRepository: CurrentWeatherRepositoryImpl())
        let wireframe = MainViewRouter(viewController: viewController)
        let presenter = MainViewPresenterImpl(interactor: interactor, wireframe: wireframe)
        viewController.presenter = presenter
        return viewController
    }
}
