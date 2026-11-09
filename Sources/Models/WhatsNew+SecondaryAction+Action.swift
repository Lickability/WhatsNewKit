import SwiftUI

// MARK: - SecondaryAction+Action

public extension WhatsNew.SecondaryAction {
    
    /// A WhatsNew Secondary Action
    enum Action {
        /// Present View
        case present(AnyView)
        /// Perform an action with the dismissal action for the release-notes presentation.
        case perform(@MainActor (DismissAction) -> Void)
        /// Dismiss the release-notes presentation.
        case dismiss
        /// Open a URL using the presentation's environment. A nil URL does nothing.
        case openURL(URL?)
        /// Legacy custom action.
        @available(*, deprecated, message: "Use perform instead. Its callback receives DismissAction; call dismiss() to dismiss.")
        case custom(@MainActor (Binding<PresentationMode>) -> Void)
    }
    
}

// MARK: - Action+present

public extension WhatsNew.SecondaryAction.Action {
    
    /// Present View on WhatsNewView
    /// - Parameters:
    ///   - content: The ViewBuilder closure that produces the Content View
    @MainActor
    static func present<Content: View>(
        @ViewBuilder
        _ content: @MainActor () -> Content
    ) -> Self {
        .present(.init(content()))
    }
    
}

// MARK: - Action+PresentedView

extension WhatsNew.SecondaryAction.Action {
    
    /// The WhatsNew Secondary Action PresentedView
    struct PresentedView: Identifiable {
        
        /// The identifier
        var id: UUID = .init()
        
        /// The View
        let view: AnyView
        
    }
    
}
