//
//  MainViewRouter.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/06/19.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

protocol MainViewWireframe {
    func showDetail()
    func showPrefectureList()
}

class MainViewRouter: MainViewWireframe {
    weak var viewController: UIViewController?

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showDetail() {

    }

    func showPrefectureList() {
        
    }
}
