import SwiftUI

/// A scrolling list of release notes grouped by version.
///
/// Embed this view in your app's navigation and supply a navigation title. Releases
/// appear in the supplied order, so pass the newest first for a chronological history.
/// Each release must have a unique version. Reading the history does not mark any
/// version as presented or run a release's primary or secondary actions.
@MainActor
public struct WhatsNewHistoryView: View {
    private let whatsNewCollection: WhatsNewCollection
    private let layout: WhatsNew.Layout
    private let versionTitle: @MainActor (WhatsNew.Version) -> Text

    /// Creates a release history from the same models used by `WhatsNewView`.
    /// - Parameters:
    ///   - whatsNewCollection: Releases in display order, with unique versions.
    ///   - layout: Feature-row spacing. Other presentation layout values are unused.
    ///   - versionTitle: A heading for each version. Defaults to “Version 1.2.3”.
    public init(
        whatsNewCollection: WhatsNewCollection,
        layout: WhatsNew.Layout = .default,
        versionTitle: @escaping @MainActor (WhatsNew.Version) -> Text = {
            Text("Version \($0.description)")
        }
    ) {
        self.whatsNewCollection = whatsNewCollection
        self.layout = layout
        self.versionTitle = versionTitle
    }

    public var body: some View {
        List(whatsNewCollection) { whatsNew in
            Section {
                ForEach(whatsNew.features, id: \.self) { feature in
                    WhatsNewFeatureView(feature: feature, layout: layout)
                        .listRowSeparator(.hidden)
                }
            } header: {
                versionTitle(whatsNew.version)
            }
        }
    }
}

#Preview("Release history") {
    NavigationStack {
        WhatsNewHistoryView(whatsNewCollection: historyPreviewReleases)
            .navigationTitle("Release Notes")
    }
}

#Preview("Release history — Accessibility") {
    NavigationStack {
        WhatsNewHistoryView(whatsNewCollection: historyPreviewReleases)
            .navigationTitle("Release Notes")
    }
    .dynamicTypeSize(.accessibility5)
}

#Preview("Custom version headings") {
    NavigationStack {
        WhatsNewHistoryView(whatsNewCollection: historyPreviewReleases) { version in
            Text("\(version.major).\(version.minor) (\(version.patch))")
        }
        .navigationTitle("Updates")
    }
}

@MainActor
private var historyPreviewReleases: WhatsNewCollection {
    [
        WhatsNew(version: "1.1.0", title: "What’s New", features: [
            .init(
                image: .init(systemName: "sparkles"),
                title: "More room for your ideas",
                subtitle: "A refreshed layout keeps your favorite features within reach, with room for longer descriptions at every text size."
            ),
            .init(image: .init(systemName: "checkmark.circle"), title: "A feature without a subtitle"),
            .init(image: .init(systemName: "bolt"), title: "An empty subtitle is omitted", subtitle: "")
        ]),
        WhatsNew(version: "1.0.0", title: "What’s New", features: [
            .init(image: .init(systemName: "star"), title: "Our first release", subtitle: "Everything you need to get started.")
        ])
    ]
}
