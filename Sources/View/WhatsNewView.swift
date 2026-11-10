import SwiftUI

// MARK: - WhatsNewView

/// A WhatsNewView
@MainActor
public struct WhatsNewView {
    
    // MARK: Properties
    
    /// The WhatsNew object
    private let whatsNew: WhatsNew
    
    /// The WhatsNewVersionStore
    private let whatsNewVersionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    private let layout: WhatsNew.Layout
    
    /// The View that is presented by the SecondaryAction
    @State
    private var secondaryActionPresentedView: WhatsNew.SecondaryAction.Action.PresentedView?
    
    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.openURL)
    private var openURL

    @Environment(\.isPresented)
    private var isPresented

    /// The legacy PresentationMode, used only for deprecated custom actions.
    @Environment(\.presentationMode)
    private var presentationMode
    
    // MARK: Initializer
    
    /// Creates a new instance of `WhatsNewView`
    /// - Parameters:
    ///   - whatsNew: The WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    public init(
        whatsNew: WhatsNew,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default
    ) {
        self.whatsNew = whatsNew
        self.whatsNewVersionStore = versionStore
        self.layout = layout
    }
    
}

// MARK: - View

extension WhatsNewView: View {
    public var body: some View {
        presentation
            .sheet(item: $secondaryActionPresentedView) { $0.view }
            .onChange(of: isPresented) { wasPresented, isPresented in
                if wasPresented && !isPresented {
                    recordPresentedVersion()
                }
            }
            .onDisappear {
                // Ignore temporary disappearance behind the secondary sheet.
                if secondaryActionPresentedView == nil {
                    recordPresentedVersion()
                }
            }
    }
}

private extension WhatsNewView {
    var presentation: some View {
        scrollContent
            .safeAreaBar(edge: .bottom, spacing: 0) { footer }
            #if !os(visionOS)
            .scrollEdgeEffectStyle(.soft, for: .bottom)
            #endif
    }

    var scrollContent: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: layout.showsScrollViewIndicators) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: layout.contentSpacing) {
                        Text(whatsNewText: whatsNew.title.text)
                            .font(.title3.bold())
                            .foregroundStyle(whatsNew.title.foregroundColor)
                            .accessibilityAddTraits(.isHeader)
                        VStack(alignment: .leading, spacing: layout.featureListSpacing) {
                            ForEach(whatsNew.features, id: \.self, content: feature)
                        }
                    }
                    if let notice = whatsNew.notice {
                        Spacer(minLength: 32)
                        noticeContent(notice)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(layout.contentPadding)
                .frame(minHeight: geometry.size.height, alignment: .top)
                .frame(maxWidth: layout.maximumContentWidth)
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
    }

    func feature(_ feature: WhatsNew.Feature) -> some View {
        HStack(alignment: .top, spacing: layout.featureHorizontalSpacing) {
            feature.image.view()
                .frame(width: layout.featureImageWidth)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: layout.featureVerticalSpacing) {
                Text(whatsNewText: feature.title)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(whatsNewText: feature.subtitle)
                    .font(.subheadline)
                    .lineSpacing(2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    func noticeContent(_ notice: WhatsNew.Notice) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = notice.image {
                image.view().accessibilityHidden(true)
            }
            Text(whatsNewText: notice.text)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    var footer: some View {
        VStack(spacing: layout.footerActionSpacing) {
            if let secondaryAction = whatsNew.secondaryAction {
                Button {
                    secondaryAction.hapticFeedback?()
                    perform(secondaryAction.action)
                } label: {
                    Text(whatsNewText: secondaryAction.title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(secondaryAction.foregroundColor)
            }
            primaryButton
        }
        .padding(layout.footerPadding)
        #if os(macOS) || os(visionOS)
        .padding(.bottom, 16)
        #endif
        .frame(maxWidth: layout.maximumContentWidth)
        .frame(maxWidth: .infinity)
    }

    var primaryButton: some View {
        Button {
            whatsNew.primaryAction.hapticFeedback?()
            dismiss()
            whatsNew.primaryAction.onDismiss?()
        } label: {
            Text(whatsNewText: whatsNew.primaryAction.title)
                .font(.body.weight(.semibold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .controlSize(.large)
        .buttonBorderShape(.capsule)
        .tint(whatsNew.primaryAction.tint)
        #if os(visionOS)
        .buttonStyle(.borderedProminent)
        #else
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
        #endif
        #if os(macOS)
        .keyboardShortcut(.defaultAction)
        #endif
    }

    func perform(_ action: WhatsNew.SecondaryAction.Action) {
        switch action {
        case .present(let view):
            secondaryActionPresentedView = .init(view: view)
        case .perform(let action):
            action(dismiss)
        case .dismiss:
            dismiss()
        case .openURL(let url):
            if let url { openURL(url) }
        case .custom(let action):
            action(presentationMode)
        }
    }

    func recordPresentedVersion() {
        guard let whatsNewVersionStore,
              !whatsNewVersionStore.hasPresented(whatsNew.version) else { return }
        whatsNewVersionStore.save(presentedVersion: whatsNew.version)
    }
}

#Preview("Short content with notice") {
    WhatsNewView(
        whatsNew: WhatsNew(
            title: "What's New",
            features: [
                .init(
                    image: .init(systemName: "star.fill"),
                    title: "A new feature",
                    subtitle: "Discover the latest improvements."
                )
            ],
            notice: .init(
                image: .init(systemName: "hand.raised.fill"),
                text: "Your information stays private. Review your choices in Settings."
            )
        )
    )
}

#Preview("Scrolling content at accessibility size") {
    WhatsNewView(
        whatsNew: WhatsNew(
            title: "What's New",
            features: (1...8).map { index in
                .init(
                    image: .init(systemName: "star.fill"),
                    title: .init("Feature \(index)"),
                    subtitle: "Discover the latest improvements, with longer descriptions that remain readable at larger text sizes."
                )
            }
        )
    )
    .dynamicTypeSize(.accessibility3)
}
