//
//  MainViewRouter.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

protocol MainViewWireframe {
    func showDetail(cityId: Int)
}

class MainViewRouter: MainViewWireframe {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showDetail(cityId: Int) {
        let detail = DetailViewBuilder.build(cityId: cityId)
        viewController?.navigationController?.pushViewController(detail, animated: true)
    }
}
