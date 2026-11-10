import SwiftUI

public extension WhatsNew {
    /// Spacing for the native release-notes presentation.
    struct Layout: Sendable {
        public var showsScrollViewIndicators: Bool
        public var contentSpacing: CGFloat
        public var contentPadding: EdgeInsets
        public var featureListSpacing: CGFloat
        public var featureImageWidth: CGFloat
        public var featureHorizontalSpacing: CGFloat
        public var featureVerticalSpacing: CGFloat
        public var footerActionSpacing: CGFloat
        public var footerPadding: EdgeInsets

        public init(
            showsScrollViewIndicators: Bool = false,
            contentSpacing: CGFloat = 24,
            contentPadding: EdgeInsets = .init(top: 76, leading: 32, bottom: 24, trailing: 32),
            featureListSpacing: CGFloat = 24,
            featureImageWidth: CGFloat = 40,
            featureHorizontalSpacing: CGFloat = 16,
            featureVerticalSpacing: CGFloat = 2,
            footerActionSpacing: CGFloat = 16,
            footerPadding: EdgeInsets = .init(top: 16, leading: 32, bottom: 0, trailing: 32)
        ) {
            self.showsScrollViewIndicators = showsScrollViewIndicators
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.featureListSpacing = featureListSpacing
            self.featureImageWidth = featureImageWidth
            self.featureHorizontalSpacing = featureHorizontalSpacing
            self.featureVerticalSpacing = featureVerticalSpacing
            self.footerActionSpacing = footerActionSpacing
            self.footerPadding = footerPadding
        }

        public static let `default` = Self()

        public mutating func reset() {
            self = .init()
        }
    }
}
