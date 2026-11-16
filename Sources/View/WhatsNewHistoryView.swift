import SwiftUI

/// A scrolling list of release notes grouped by version.
///
/// Embed this view in your app's navigation and supply a navigation title.
/// Releases appear in the supplied order. Pass newest first for reverse chronological order.
/// Multiple builds of the same marketing version can appear as separate entries.
/// Reading the history does not mark any version as presented or run release actions.
@MainActor
public struct WhatsNewHistoryView: View {
    private let whatsNewCollection: WhatsNewCollection
    private let versionTitle: @MainActor (WhatsNew) -> Text

    /// Creates a release history from the same models used by `WhatsNewView`.
    /// - Parameters:
    ///   - whatsNewCollection: Releases in display order, including their historical build numbers.
    ///   - versionTitle: A heading for each release. Defaults to “1.2.3 (456)”, or “1.2.3” if the build is unknown.
    public init(
        whatsNewCollection: WhatsNewCollection,
        versionTitle: (@MainActor (WhatsNew) -> Text)? = nil
    ) {
        self.whatsNewCollection = whatsNewCollection
        self.versionTitle = versionTitle ?? { Text(verbatim: $0.historyVersionTitle) }
    }

    public var body: some View {
        List(Array(whatsNewCollection.enumerated()), id: \.offset) { _, whatsNew in
            Section {
                ForEach(whatsNew.features, id: \.self) { feature in
                    WhatsNewFeatureView(feature: feature, layout: .default)
                        .listRowSeparator(.hidden)
                }
            } header: {
                versionTitle(whatsNew)
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
        WhatsNewHistoryView(whatsNewCollection: historyPreviewReleases) { release in
            Text("Version \(release.version.description)")
        }
        .navigationTitle("Updates")
    }
}

@MainActor
private var historyPreviewReleases: WhatsNewCollection {
    [
        WhatsNew(version: "1.1.0", buildNumber: "110", title: "What’s New", features: [
            .init(
                image: .init(systemName: "sparkles"),
                title: "More room for your ideas",
                subtitle: "A refreshed layout keeps your favorite features within reach, with room for longer descriptions at every text size."
            ),
            .init(image: .init(systemName: "checkmark.circle"), title: "A feature without a subtitle"),
            .init(image: .init(systemName: "bolt"), title: "An empty subtitle is omitted", subtitle: "")
        ]),
        WhatsNew(version: "1.0.0", buildNumber: "100", title: "What’s New", features: [
            .init(image: .init(systemName: "star"), title: "Our first release", subtitle: "Everything you need to get started.")
        ])
    ]
}

extension WhatsNew {
    var historyVersionTitle: String {
        guard let buildNumber, !buildNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return version.description
        }
        return "\(version.description) (\(buildNumber))"
    }
}
