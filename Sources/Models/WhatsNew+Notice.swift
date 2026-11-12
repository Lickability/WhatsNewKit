import Foundation

public extension WhatsNew {
    /// Supplemental information that scrolls with the content, so long notices remain reachable.
    struct Notice {
        public var image: Feature.Image?
        /// Supports attributed text and links, like feature descriptions.
        public var text: Text

        public init(image: Feature.Image? = nil, text: Text) {
            self.image = image
            self.text = text
        }
    }
}
