//
//  BaseNavigationController.swift
//  CollectionViewTransition
//
//  Created by Adam Wulf on 8/21/21.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = BaseCollectionViewController()
        viewControllers = [vc]
    }
}
