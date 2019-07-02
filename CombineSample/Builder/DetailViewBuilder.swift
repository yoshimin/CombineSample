//
//  DetailViewBuilder.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/28.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

struct DetailViewBuilder {
    static func build(cityId: Int) -> DetailViewController {
        let viewController = StoryboardScene.DetailView.initialScene.instantiate()
        let interactor = DetailViewInteractorImpl(forecastRepository: ForecastRepositoryImpl())
        let wireframe = DetailViewRouter(viewController: viewController)
        let presenter = DetailViewPresenterImpl(interactor: interactor, wireframe: wireframe, cityId: cityId)
        viewController.presenter = presenter
        return viewController
    }
}
