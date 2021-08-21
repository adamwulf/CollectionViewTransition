//
//  APLTransitionController.swift
//  CollectionViewTransition
//
//  Created by Adam Wulf on 8/21/21.
//
//  From https://github.com/timarnold/UICollectionView-Transition-Demo
//

import UIKit

protocol APLTransitionControllerDelegate {
    func interactionBeganAt(point: CGPoint)
}

class APLTransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {

    var delegate: APLTransitionControllerDelegate?
    var navigationOperation: UINavigationController.Operation?
    var hasActiveInteraction: Bool
    var collectionView: UICollectionView

    private var transitionLayout: UICollectionViewTransitionLayout?
    private var context: UIViewControllerContextTransitioning?
    private var initialPinchDistance: CGFloat

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.hasActiveInteraction = false
        self.initialPinchDistance = 0

        super.init()

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        collectionView.addGestureRecognizer(pinchGesture)
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // noop
    }

    // MARK: - UIViewControllerInteractiveTransitioning

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? UICollectionViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? UICollectionViewController,
            let fvccv = fromViewController.collectionView
        else {
            return
        }
        self.context = transitionContext
        let tvccvl = toViewController.collectionViewLayout

        self.transitionLayout = fvccv.startInteractiveTransition(to: tvccvl, completion: { didFinish, didComplete in
            self.context?.containerView.addSubview(toViewController.view)
            self.context?.completeTransition(didComplete)

            if didComplete {
                self.collectionView.delegate = toViewController
            } else {
                self.collectionView.delegate = fromViewController
            }
            self.transitionLayout = nil
            self.context = nil
            self.hasActiveInteraction = false
        })
    }

    // MARK: - Gestures

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .ended {
            endInteraction(success: true)
            return
        } else if gesture.state == .cancelled {
            endInteraction(success: false)
            return
        }

        guard gesture.numberOfTouches >= 2 else { return }

        let point1 = gesture.location(ofTouch: 0, in: gesture.view)
        let point2 = gesture.location(ofTouch: 1, in: gesture.view)
        let dist = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
        let point = gesture.location(in: gesture.view)

        if gesture.state == .began {
            if hasActiveInteraction {
                return
            }
            initialPinchDistance = dist
            hasActiveInteraction = true
            delegate?.interactionBeganAt(point: point)
            return
        }

        if !hasActiveInteraction {
            return
        }

        if gesture.state == .changed {
            var deltaDist = dist - initialPinchDistance
            if navigationOperation == .pop {
                deltaDist = -deltaDist
            }
            let width = collectionView.bounds.size.width
            let height = collectionView.bounds.size.height
            let dimension = sqrt(width * width + height * height)
            let progress = max(min(deltaDist / dimension, 1.0), 0.0)
            updateInteraction(progress: progress)
            return
        }
    }

    // MARK: - Helpers

    func updateInteraction(progress: CGFloat) {
        guard
            let context = context,
            let transitionLayout = transitionLayout
        else {
            return
        }

        if progress != transitionLayout.transitionProgress {
            transitionLayout.transitionProgress = progress
            transitionLayout.invalidateLayout()
            context.updateInteractiveTransition(progress)
        }
    }

    func endInteraction(success: Bool) {
        guard
            let context = context,
            let transitionLayout = transitionLayout
        else {
            hasActiveInteraction = false
            return
        }

        if transitionLayout.transitionProgress > 0.5 && success {
            collectionView.finishInteractiveTransition()
            context.finishInteractiveTransition()
        } else {
            collectionView.cancelInteractiveTransition()
            context.cancelInteractiveTransition()
        }
    }
}
