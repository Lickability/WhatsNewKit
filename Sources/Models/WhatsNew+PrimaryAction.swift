import SwiftUI

// MARK: - WhatsNew+PrimaryAction

public extension WhatsNew {
    
    /// The WhatsNew PrimaryAction
    struct PrimaryAction {
        
        // MARK: Properties
        
        /// The title Text
        public var title: Text
        
        /// The tint used by the native prominent button style.
        public var tint: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// Called when the primary button requests dismissal, before its animation completes.
        public var onDismiss: (@MainActor () -> Void)?
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.PrimaryAction`
        /// - Parameters:
        ///   - title: The title Text. Default value `Continue`
        ///   - tint: The native button tint. Default value `.accentColor`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - onDismiss: Called when the primary button requests dismissal. Use the sheet modifier’s onDismiss for completion. Default value `nil`
        public init(
            title: Text = "Continue",
            tint: Color = .accentColor,
            hapticFeedback: HapticFeedback? = nil,
            onDismiss: (@MainActor () -> Void)? = nil
        ) {
            self.title = title
            self.tint = tint
            self.hapticFeedback = hapticFeedback
            self.onDismiss = onDismiss
        }
        
    }
    
}
