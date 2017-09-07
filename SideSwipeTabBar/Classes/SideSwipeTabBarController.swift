import UIKit

class SideSwipeTabBarController: UITabBarController {
    let percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()

    lazy var leftEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SideSwipeTabBarController.didPan))
        edgePanGestureRecognizer.edges = .left

        return edgePanGestureRecognizer
    }()

    lazy var rightEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SideSwipeTabBarController.didPan))
        edgePanGestureRecognizer.edges = .right

        return edgePanGestureRecognizer
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    func setup() {
        delegate = self

        addGestureRecognizers(toIndex: 0)
    }

    func addGestureRecognizers(toIndex index: Int) {
        if let viewControllers = viewControllers, index >= 0 && index < viewControllers.count {
            addGestureRecognizers(to: viewControllers[index])
        }
    }

    func addGestureRecognizers(to viewController: UIViewController) {
        viewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
        viewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
    }

    var edgePanGestureRecognizerStartLocation: CGPoint?
    var isAnimating = false

    func didPan(edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let xOffset = (edgePanGestureRecognizerStartLocation?.x ?? 0) - edgePanGestureRecognizer.location(in: edgePanGestureRecognizer.view).x
        let percentage = 1 - abs(xOffset / (edgePanGestureRecognizer.view?.bounds.width ?? 320)).inBetween(minimumValue: 0, maximumValue: 1)

        switch edgePanGestureRecognizer.state {
        case .began:
            isAnimating = true

            selectedIndex += (edgePanGestureRecognizer.velocity(in: view).x < 0) ? 1 : -1

            edgePanGestureRecognizerStartLocation = edgePanGestureRecognizer.location(in: edgePanGestureRecognizer.view)
        case .changed:
            percentDrivenInteractiveTransition.update(percentage)
        case .ended:
            endAnimating(finished: percentage > 0.5)
        case .cancelled, .failed:
            endAnimating(finished: false)
        default:
            break
        }
    }

    func endAnimating(finished: Bool) {
        if finished {
            addGestureRecognizers(toIndex: selectedIndex)

            percentDrivenInteractiveTransition.finish()
        } else {
            percentDrivenInteractiveTransition.cancel()
        }

        isAnimating = false
    }
}

extension SideSwipeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isAnimating ? percentDrivenInteractiveTransition : nil
    }

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isAnimating ? self : nil
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addGestureRecognizers(to: viewController)
    }
}

extension SideSwipeTabBarController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }

        if let transitionType = transitionTypeFrom(toViewController: toViewController, fromViewController: fromViewController) {
            transitionType.addSubviews(fromView: fromViewController.view, toView: toViewController.view, containerView: transitionContext.containerView)
            transitionType.setPositionBeforeAnimation(fromView: fromViewController.view, toView: toViewController.view)

            UIView.animate(
                withDuration: 0.5,
                animations: {
                    transitionType.setPositionAfterAnimation(fromView: fromViewController.view, toView: toViewController.view)
            },
                completion: { _ in
                    if transitionContext.transitionWasCancelled {
                        toViewController.view.removeFromSuperview()
                    } else {
                        fromViewController.view.removeFromSuperview()
                    }

                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    func transitionTypeFrom(toViewController: UIViewController, fromViewController: UIViewController) -> SideSwipeAnimatedTransitioningType? {
        if let viewControllers = viewControllers,
            let indexOfToViewController = viewControllers.index(of: toViewController),
            let indexOfFromViewController = viewControllers.index(of: fromViewController) {
            return indexOfFromViewController < indexOfToViewController ? .toRight : .toLeft
        }

        return nil
    }
}
