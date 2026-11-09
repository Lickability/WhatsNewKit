import SwiftUI

// MARK: - View+sheet(whatsNew:)

public extension View {

    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func sheet(
        whatsNew: Binding<WhatsNew?>,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            ManualWhatsNewSheetViewModifier(
                whatsNew: whatsNew,
                versionStore: versionStore,
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
}

// MARK: - ManualWhatsNewSheetViewModifier

/// A Manual WhatsNew Sheet ViewModifier
private struct ManualWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    let whatsNew: Binding<WhatsNew?>
    
    /// The optional WhatsNewVersionStore
    let versionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    let layout: WhatsNew.Layout
    
    /// The closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    /// The actual presentation, retained until the outer sheet finishes dismissing.
    @State private var presentation = WhatsNewPresentation()

    func body(content: Content) -> some View {
        content.sheet(
            item: Binding(
                get: {
                    presentation.eligibleItem(whatsNew.wrappedValue, versionStore: versionStore)
                },
                set: { whatsNew.wrappedValue = $0 }
            ),
            onDismiss: {
                presentation.didDismiss()
                onDismiss?()
            }
        ) { item in
            WhatsNewView(whatsNew: item, layout: layout)
                .onAppear {
                    presentation.didAppear(item, versionStore: versionStore)
                }
        }
    }
}

// MARK: - View+whatsNewSheet()

public extension View {
    
    /// Auto-Presents a WhatsNewView to the user if needed based on the `WhatsNewEnvironment`
    /// - Parameters:
    ///   - layout: The optional custom WhatsNew Layout. Default value `nil`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func whatsNewSheet(
        layout: WhatsNew.Layout? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            AutomaticWhatsNewSheetViewModifier(
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
}

// MARK: - WhatsNewSheetViewModifier

/// A Automatic WhatsNew Sheet ViewModifier
private struct AutomaticWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// The optional WhatsNew Layout
    let layout: WhatsNew.Layout?
    
    /// The optional closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    @State private var isDismissed = false

    @Environment(\.whatsNew)
    private var whatsNewEnvironment

    func body(content: Content) -> some View {
        content
            .sheet(
                whatsNew: Binding(
                    get: { isDismissed ? nil : whatsNewEnvironment.whatsNew() },
                    set: { isDismissed = $0 == nil }
                ),
                versionStore: whatsNewEnvironment.whatsNewVersionStore,
                layout: layout ?? whatsNewEnvironment.defaultLayout,
                onDismiss: onDismiss
            )
    }
}

#Preview("Manual presentation") {
    SheetPreview()
}

private struct SheetPreview: View {
    @State private var whatsNew: WhatsNew?

    var body: some View {
        Button("Show What's New") {
            whatsNew = WhatsNew(title: "What's New", features: [])
        }
        .sheet(whatsNew: $whatsNew)
    }
}

#Preview("Automatic presentation") {
    Text("Example content")
        .whatsNewSheet()
        .environment(\.whatsNew, WhatsNewEnvironment(whatsNewCollection: [
            WhatsNew(title: "What's New", features: [])
        ]))
}
