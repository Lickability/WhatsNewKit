import SwiftUI
import WhatsNewKit

// MARK: - ExamplesView

/// The ExamplesView
struct ExamplesView {
    
    /// The Examples
    private let examples = WhatsNew.Example.allCases
    
    /// The currently presented WhatsNew object
    @State
    private var whatsNew: WhatsNew?
    
}

// MARK: - View

extension ExamplesView: View {
    
    /// The content and behavior of the view
    var body: some View {
        List {
            NavigationLink("Presentation lifecycle") {
                PresentationExampleView()
            }
            Section(
                header: Text(
                    verbatim: "Examples"
                ),
                footer: Text(
                    verbatim: "Tap on an example to manually present a WhatsNewView"
                )
            ) {
                ForEach(
                    self.examples,
                    id: \.rawValue
                ) { example in
                    Button(
                        action: {
                            self.whatsNew = example.whatsNew
                        }
                    ) {
                        Text(
                            verbatim: example.displayName
                        )
                    }
                }
            }
        }
        .navigationTitle("WhatsNewKit")
        .sheet(
            whatsNew: self.$whatsNew
        )
    }
    
}

// MARK: - WhatsNew+Example

private extension WhatsNew {
    
    /// A WhatsNew Example
    enum Example: String, Codable, Hashable, CaseIterable {
        /// Calendar
        case calendar
        /// Maps
        case maps
        /// Translate
        case translate
    }
    
}

// MARK: - WhatsNew+Example+displayName

private extension WhatsNew.Example {
    
    /// The user friendly display name
    var displayName: String {
        self.rawValue.prefix(1).capitalized + self.rawValue.dropFirst()
    }
    
}

// MARK: - WhatsNew+Example+whatsNew

private extension WhatsNew.Example {
    
    /// The WhatsNew
    var whatsNew: WhatsNew {
        switch self {
        case .calendar:
            return .init(
                title: "What's New in Calendar",
                features: [
                    .init(
                        image: .init(
                            systemName: "envelope",
                            foregroundColor: .red
                        ),
                        title: "Found Events",
                        subtitle: "Siri suggests events found in Mail, Messages, and Safari, so you can add them easily, such as flight reservations and hotel bookings."
                    ),
                    .init(
                        image: .init(
                            systemName: "clock",
                            foregroundColor: .red
                        ),
                        title: "Time to Leave",
                        subtitle: "Calendar uses Apple Maps to look up locations, traffic conditions, and transit options to tell you when it's time to leave."
                    ),
                    .init(
                        image: .init(
                            systemName: "location",
                            foregroundColor: .red
                        ),
                        title: "Location Suggestions",
                        subtitle: "Calendar suggests locations based on your past events and significant locations."
                    )
                ],
                primaryAction: .init(
                    backgroundColor: .red
                )
            )
        case .maps:
            return .init(
                title: "What's New in Maps",
                features: [
                    .init(
                        image: .init(
                            systemName: "map.fill",
                            foregroundColor: .green
                        ),
                        title: "Updated Map Style",
                        subtitle: "An improved design makes it easier to navigate and explore the map."
                    ),
                    .init(
                        image: .init(
                            systemName: "mappin.and.ellipse",
                            foregroundColor: .pink
                        ),
                        title: "All-New Place Cards",
                        subtitle: "Completely redesigned place cards make it easier to learn about and interact with places."
                    ),
                    .init(
                        image: .init(
                            systemName: "magnifyingglass",
                            foregroundColor: .blue
                        ),
                        title: "Improved Search",
                        subtitle: "Finding places is now easier with filters and automatic updates when you're browsing results on the map."
                    )
                ],
                primaryAction: .init(backgroundColor: .blue),
                secondaryAction: .init(
                    title: "About Apple Maps & Privacy",
                    foregroundColor: .blue,
                    action: .openURL(.init(string: "maps://"))
                )
            )
        case .translate:
            return .init(
                title: .init(
                    text: .init(
                        "What's New in "
                        + AttributedString(
                            "Translate",
                            attributes: .foregroundColor(.cyan)
                        )
                    )
                ),
                features: [
                    .init(
                        image: .init(
                            systemName: "rectangle.portrait.bottomthird.inset.filled",
                            foregroundColor: .cyan
                        ),
                        title: "Conversation Views",
                        subtitle: "Choose a side-by-side or face-to-face conversation view."
                    ),
                    .init(
                        image: .init(
                            systemName: "mic",
                            foregroundColor: .cyan
                        ),
                        title: "Auto Translate",
                        subtitle: "Respond in conversations without tapping the microphone button."
                    ),
                    .init(
                        image: .init(
                            systemName: "iphone",
                            foregroundColor: .cyan
                        ),
                        title: "System-Wide Translation",
                        subtitle: "Translate selected text anywhere on your iPhone."
                    )
                ],
                primaryAction: .init(
                    backgroundColor: .cyan
                ),
                secondaryAction: .init(
                    title: "About Translation & Privacy",
                    foregroundColor: .cyan,
                    action: .openURL(
                        .init(string: "https://apple.com/privacy")
                    )
                )
            )
        }
    }
    
}

// MARK: - AttributeContainer+foregroundColor

private extension AttributeContainer {
    
    /// A AttributeContainer with a given foreground color
    /// - Parameter color: The foreground color
    static func foregroundColor(
        _ color: Color
    ) -> Self {
        var container = Self()
        container.foregroundColor = color
        return container
    }
    
}

#Preview {
    NavigationStack { ExamplesView() }
}

private struct PresentationExampleView: View {
    @State private var store = InMemoryWhatsNewVersionStore()
    @State private var whatsNew: WhatsNew?
    @State private var primaryActions = 0
    @State private var dismissals = 0
    @State private var openedURLs = 0

    var body: some View {
        List {
            Section("Present") {
                Button("Show nested details") {
                    show(.present { PresentationDetailsView(store: store) })
                }
                Button("Show custom dismissal") {
                    show(.perform { dismiss in dismiss() })
                }
                Button("Show URL action") {
                    show(.openURL(URL(string: "https://example.com/release-notes")))
                }
                Button("Reset seen version") { store.removeAll(); dismissals = 0 }
            }
            Section("Results") {
                Text("Seen: \(store.hasPresented("1.0.0") ? "yes" : "no")")
                Text("Primary actions: \(primaryActions)")
                Text("Completed dismissals: \(dismissals)")
                Text("Handled URLs: \(openedURLs)")
                PresentationCounter()
            }
        }
        .navigationTitle("Presentation lifecycle")
        .sheet(whatsNew: $whatsNew, versionStore: store) { dismissals += 1 }
        .environment(\.openURL, OpenURLAction { _ in
            openedURLs += 1
            return .handled
        })
    }

    private func show(_ action: WhatsNew.SecondaryAction.Action) {
        whatsNew = WhatsNew(
            version: "1.0.0",
            title: "Release Notes",
            features: [.init(image: .init(systemName: "checkmark.circle"),
                             title: "Presentation lifecycle",
                             subtitle: "The version is recorded when these release notes finish dismissing.")],
            primaryAction: .init(onDismiss: { primaryActions += 1 }),
            secondaryAction: .init(title: "Secondary action", action: action)
        )
    }
}

private struct PresentationDetailsView: View {
    let store: InMemoryWhatsNewVersionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Release notes seen: \(store.hasPresented("1.0.0") ? "yes" : "no")")
                .navigationTitle("Details")
                .toolbar { Button("Done") { dismiss() } }
        }
    }
}

private struct PresentationCounter: View {
    @State private var count = 0
    var body: some View {
        Button("Parent counter: \(count)") { count += 1 }
    }
}

#Preview("Presentation lifecycle") {
    NavigationStack { PresentationExampleView() }
}

#Preview("Nested details") {
    PresentationDetailsView(store: InMemoryWhatsNewVersionStore())
}

#Preview("Preserved parent state") {
    PresentationCounter()
}
