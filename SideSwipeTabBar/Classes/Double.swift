import UIKit

extension CGFloat {
    func inBetween(minimumValue: CGFloat, maximumValue: CGFloat) -> CGFloat {
        return CGFloat.minimum(
            CGFloat.maximum(minimumValue, self),
            maximumValue
        )
    }
}
