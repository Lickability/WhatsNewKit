import Foundation

// MARK: - WhatsNew

/// A WhatsNew object
public struct WhatsNew {
    
    // MARK: Properties
    
    /// The Version
    public var version: Version
    
    /// The build number associated with this release, when known.
    /// Historical releases should provide their shipped build rather than the current app's build.
    public var buildNumber: String?

    /// The Title
    public var title: Title
    
    /// The Features
    public var features: [Feature]
    
    /// The PrimaryAction
    public var primaryAction: PrimaryAction
    
    /// The optional SecondaryAction
    public var secondaryAction: SecondaryAction?
    
    /// Optional supplemental information, such as a privacy notice.
    public var notice: Notice?

    // MARK: Initializer
    
    /// Creates a new instance of `WhatsNew`
    /// - Parameters:
    ///   - version: The marketing version for this release.
    ///   - buildNumber: Its build number, or `nil` if unavailable.
    ///   - title: The Title
    ///   - items: The Features
    ///   - primaryAction: The PrimaryAction. Default value `.init()`
    ///   - secondaryAction: The optional SecondaryAction
    ///   - notice: Optional information shown below the features. Default value `nil`
    public init(
        version: Version,
        buildNumber: String? = nil,
        title: Title,
        features: [Feature],
        primaryAction: PrimaryAction = .init(),
        secondaryAction: SecondaryAction? = nil,
        notice: Notice? = nil
    ) {
        self.version = version
        self.buildNumber = buildNumber
        self.title = title
        self.features = features
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.notice = notice
    }

    /// Creates release notes for the currently running app.
    ///
    /// The marketing version and build number are read from the main bundle. Use
    /// `init(version:buildNumber:title:features:primaryAction:secondaryAction:notice:)`
    /// to retain the correct version and build when archiving an older release.
    public init(
        title: Title,
        features: [Feature],
        primaryAction: PrimaryAction = .init(),
        secondaryAction: SecondaryAction? = nil,
        notice: Notice? = nil
    ) {
        self.init(
            version: .current(),
            buildNumber: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
            title: title,
            features: features,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            notice: notice
        )
    }
    
}

// MARK: - Identifiable

extension WhatsNew: Identifiable {
    
    /// The stable identity of the entity associated with this instance.
    public var id: Version {
        self.version
    }
    
}
