//
//  BaseNavigationController.swift
//  CollectionViewTransition
//
//  Created by Adam Wulf on 8/21/21.
//

import UIKit

class BasicCollectionViewController: UICollectionViewController {
    func nextViewControllerAt(point: CGPoint) -> BasicCollectionViewController? {
        return nil
    }
}

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, APLTransitionControllerDelegate {
    let transitionController: APLTransitionController

    required init?(coder aDecoder: NSCoder) {
        let vc = BaseCollectionViewController()
        transitionController = APLTransitionController(collectionView: vc.collectionView)

        super.init(coder: aDecoder)

        transitionController.delegate = self
        viewControllers = [vc]
        delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController === transitionController {
            return transitionController
        }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            fromVC as? BasicCollectionViewController != nil,
            toVC as? BasicCollectionViewController != nil,
            transitionController.hasActiveInteraction
        else {
            return nil
        }

        transitionController.navigationOperation = operation
        return transitionController
    }

    // MARK: - APLTransitionControllerDelegate

    func interactionBeganAt(point: CGPoint) {
        guard let presentingVC = topViewController as? BasicCollectionViewController else { return }

        if let presentedVC = presentingVC.nextViewControllerAt(point: point) {
            pushViewController(presentedVC, animated: true)
        } else {
            popViewController(animated: true)
        }
    }
}
