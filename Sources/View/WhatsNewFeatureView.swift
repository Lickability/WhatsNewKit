import SwiftUI

/// The shared feature row used by the launch presentation and release history.
@MainActor
struct WhatsNewFeatureView: View {
    let feature: WhatsNew.Feature
    let layout: WhatsNew.Layout

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        featureLayout {
            feature.image.view()
                .frame(width: dynamicTypeSize.isAccessibilitySize ? nil : layout.featureImageWidth)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: layout.featureVerticalSpacing) {
                Text(whatsNewText: feature.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                if hasSubtitle, let subtitle = feature.subtitle {
                    Text(whatsNewText: subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    private var hasSubtitle: Bool {
        (feature.subtitle?.attributedString.length ?? 0) > 0
    }

    private var featureLayout: AnyLayout {
        if dynamicTypeSize.isAccessibilitySize {
            AnyLayout(VStackLayout(alignment: .leading, spacing: layout.featureVerticalSpacing))
        } else {
            AnyLayout(HStackLayout(alignment: hasSubtitle ? .top : .center, spacing: layout.featureHorizontalSpacing))
        }
    }
}

#Preview("Feature at largest accessibility size") {
    WhatsNewFeatureView(
        feature: .init(
            image: .init(systemName: "sparkles"),
            title: "More room for your ideas",
            subtitle: "Longer descriptions wrap without competing with the feature icon."
        ),
        layout: .default
    )
    .padding()
    .dynamicTypeSize(.accessibility5)
}

#Preview("Title-only feature") {
    WhatsNewFeatureView(
        feature: .init(image: .init(systemName: "checkmark.circle"), title: "Faster launch"),
        layout: .default
    )
    .padding()
}
