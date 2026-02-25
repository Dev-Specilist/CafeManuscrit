import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Font {
    static func app(size: CGFloat) -> Font {
        #if canImport(UIKit)
        if UIFont(name: "Inter", size: size) != nil {
            return .custom("Inter", size: size)
        }
        #endif
        return .system(size: size)
    }
}
