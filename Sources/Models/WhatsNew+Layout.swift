import SwiftUI

public extension WhatsNew {
    /// Spacing for the native release-notes presentation.
    struct Layout: Sendable {
        /// Whether the scroll view indicators are visible.
        public var showsScrollViewIndicators: Bool
        /// The vertical spacing between the title and the feature list.
        public var contentSpacing: CGFloat
        /// The padding around the scrollable content.
        public var contentPadding: EdgeInsets
        /// The vertical spacing between features.
        public var featureListSpacing: CGFloat
        /// The width reserved for each feature image.
        public var featureImageWidth: CGFloat
        /// The horizontal spacing between a feature image and its text.
        public var featureHorizontalSpacing: CGFloat
        /// The vertical spacing between a feature title and its subtitle.
        public var featureVerticalSpacing: CGFloat
        /// The vertical spacing between the footer actions.
        public var footerActionSpacing: CGFloat
        /// The padding around the footer actions.
        public var footerPadding: EdgeInsets

        /// Creates a new instance of `WhatsNew.Layout`.
        /// - Parameters:
        ///   - showsScrollViewIndicators: Whether scroll view indicators are visible. Defaults to `false`.
        ///   - contentSpacing: The spacing between the title and feature list. Defaults to `24` points.
        ///   - contentPadding: The scrollable content padding. Defaults to `top: 76, leading: 32, bottom: 24, trailing: 32`.
        ///   - featureListSpacing: The vertical spacing between features. Defaults to `24` points.
        ///   - featureImageWidth: The width reserved for each feature image. Defaults to `40` points.
        ///   - featureHorizontalSpacing: The spacing between a feature image and its text. Defaults to `16` points.
        ///   - featureVerticalSpacing: The spacing between a feature title and its subtitle. Defaults to `2` points.
        ///   - footerActionSpacing: The vertical spacing between footer actions. Defaults to `16` points.
        ///   - footerPadding: The footer action padding. Defaults to `top: 16, leading: 32, bottom: 0, trailing: 32`.
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

        /// The standard layout. Pass a customized copy to a view or environment.
        public static let `default` = Self()

        /// Resets the layout to its default values.
        public mutating func reset() {
            self = .init()
        }
    }
}
