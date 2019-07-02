//
//  DetailViewRouter.swift
//  CombineSample
//
//  Created by SHINGAI YOSHIMI on 2019/07/02.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

protocol DetailViewWireframe {
    func dismiss()
}

class DetailViewRouter: DetailViewWireframe {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

