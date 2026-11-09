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
    
    /// The content and behavior of the view.
    public var body: some View {
        ZStack {
            // Content ScrollView
            ScrollView(
                .vertical,
                showsIndicators: self.layout.showsScrollViewIndicators
            ) {
                // Content Stack
                VStack(
                    spacing: self.layout.contentSpacing
                ) {
                    // Title
                    self.title
                    // Feature List
                    VStack(
                        alignment: .leading,
                        spacing: self.layout.featureListSpacing
                    ) {
                        // Feature
                        ForEach(
                            self.whatsNew.features,
                            id: \.self,
                            content: self.feature
                        )
                    }
                    .modifier(FeaturesPadding())
                    .padding(self.layout.featureListPadding)
                }
                .padding(.horizontal)
                .padding(self.layout.contentPadding)
                // ScrollView bottom content inset
                Color.clear
                    .padding(
                        .bottom,
                        self.layout.scrollViewBottomContentInset
                    )
            }
            #if os(iOS)
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            #endif
            // Footer
            VStack {
                Spacer()
                self.footer
                    .modifier(FooterPadding())
                    #if os(iOS)
                    .background(
                        UIVisualEffectView
                            .Representable()
                            .edgesIgnoringSafeArea(.horizontal)
                            .padding(self.layout.footerVisualEffectViewPadding)
                    )
                    #endif
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(
            item: self.$secondaryActionPresentedView,
            content: { $0.view }
        )
        .onChange(of: isPresented) { wasPresented, isPresented in
            if wasPresented && !isPresented {
                self.recordPresentedVersion()
            }
        }
        .onDisappear {
            // Managed sheets record at their outer onDismiss. For a directly hosted
            // view, ignore temporary disappearance behind its secondary sheet.
            if self.secondaryActionPresentedView == nil {
                self.recordPresentedVersion()
            }
        }
    }
    
}

private extension WhatsNewView {
    func recordPresentedVersion() {
        guard let whatsNewVersionStore,
              !whatsNewVersionStore.hasPresented(whatsNew.version) else { return }
        whatsNewVersionStore.save(presentedVersion: whatsNew.version)
    }
}

// MARK: - Title

private extension WhatsNewView {
    
    /// The Title View
    var title: some View {
        Text(
            whatsNewText: self.whatsNew.title.text
        )
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

// MARK: - Feature

private extension WhatsNewView {
    
    /// The Feature View
    /// - Parameter feature: A WhatsNew Feature
    func feature(
        _ feature: WhatsNew.Feature
    ) -> some View {
        HStack(
            alignment: self.layout.featureHorizontalAlignment,
            spacing: self.layout.featureHorizontalSpacing
        ) {
            feature
                .image
                .view()
                .frame(width: self.layout.featureImageWidth)
            VStack(
                alignment: .leading,
                spacing: self.layout.featureVerticalSpacing
            ) {
                Text(
                    whatsNewText: feature.title
                )
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                Text(
                    whatsNewText: feature.subtitle
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
        }.accessibilityElement(children: .combine)
    }
    
}

// MARK: - Footer

private extension WhatsNewView {
    
    /// The Footer View
    var footer: some View {
        VStack(
            spacing: self.layout.footerActionSpacing
        ) {
            // Check if a secondary action is available
            if let secondaryAction = self.whatsNew.secondaryAction {
                // Secondary Action Button
                Button(
                    action: {
                        // Invoke HapticFeedback, if available
                        secondaryAction.hapticFeedback?()
                        // Switch on Action
                        switch secondaryAction.action {
                        case .present(let view):
                            // Set secondary action presented view
                            self.secondaryActionPresentedView = .init(view: view)
                        case .perform(let action):
                            action(self.dismiss)
                        case .dismiss:
                            self.dismiss()
                        case .openURL(let url):
                            if let url {
                                self.openURL(url)
                            }
                        case .custom(let action):
                            // Invoke action with PresentationMode
                            action(self.presentationMode)
                        }
                    }
                ) {
                    Text(
                        whatsNewText: secondaryAction.title
                    )
                }
                #if os(macOS)
                .buttonStyle(
                    PlainButtonStyle()
                )
                #endif
                .foregroundColor(secondaryAction.foregroundColor)
            }
            // Primary Action Button
            Button(
                action: {
                    // Invoke HapticFeedback, if available
                    self.whatsNew.primaryAction.hapticFeedback?()
                    // Dismiss
                    self.dismiss()
                    // Invoke on dismiss, if available
                    self.whatsNew.primaryAction.onDismiss?()
                }
            ) {
                Text(
                    whatsNewText: self.whatsNew.primaryAction.title
                )
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    primaryAction: self.whatsNew.primaryAction,
                    layout: self.layout
                )
            )
            #if os(macOS)
            .keyboardShortcut(.defaultAction)
            #endif
        }
    }
    
}

#Preview("Short content") {
    WhatsNewView(
        whatsNew: WhatsNew(
            title: "What's New",
            features: [
                .init(
                    image: .init(systemName: "star.fill"),
                    title: "A new feature",
                    subtitle: "Discover the latest improvements."
                )
            ]
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
