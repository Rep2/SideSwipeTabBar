import UIKit

enum SideSwipeAnimatedTransitioningType {
    case toLeft
    case toRight

    func addSubviews(fromView: UIView, toView: UIView, containerView: UIView) {
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
    }

    func setPositionBeforeAnimation(fromView: UIView, toView: UIView) {
        switch self {
        case .toLeft:
            fromView.frame.origin.x = 0
            toView.frame.origin.x = -toView.bounds.width
        case .toRight:
            fromView.frame.origin.x = 0
            toView.frame.origin.x = toView.bounds.width
        }
    }

    func setPositionAfterAnimation(fromView: UIView, toView: UIView) {
        switch self {
        case .toLeft:
            fromView.frame.origin.x = toView.bounds.width
            toView.frame.origin.x = 0
        case .toRight:
            fromView.frame.origin.x = -toView.bounds.width
            toView.frame.origin.x = 0
        }
    }
}
