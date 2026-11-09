import Foundation
import os

// MARK: - InMemoryWhatsNewVersionStore

/// The InMemoryWhatsNewVersionStore
public final class InMemoryWhatsNewVersionStore: Sendable {
    
    // MARK: Static-Properties
    
    /// The shared `InMemoryWhatsNewVersionStore` instance
    public static let shared = InMemoryWhatsNewVersionStore()
    
    // MARK: Properties
    
    /// The Versions
    /// Reading returns a snapshot; assigning replaces the stored versions.
    public var versions: Set<WhatsNew.Version> {
        get { storage.withLock { $0 } }
        set { storage.withLock { $0 = newValue } }
    }

    private let storage = OSAllocatedUnfairLock(initialState: Set<WhatsNew.Version>())
    
    // MARK: Initializer
    
    /// Creates a new instance of `InMemoryWhatsNewVersionStore`
    public init() {}
    
}

// MARK: - WriteableWhatsNewVersionStore

extension InMemoryWhatsNewVersionStore: WriteableWhatsNewVersionStore {
    
    /// Save presented WhatsNew Version
    /// - Parameter version: The presented WhatsNew Version that should be saved
    public func save(
        presentedVersion version: WhatsNew.Version
    ) {
        self.storage.withLock { _ = $0.insert(version) }
    }
    
}

// MARK: - ReadableWhatsNewVersionStore

extension InMemoryWhatsNewVersionStore: ReadableWhatsNewVersionStore {
    
    /// The WhatsNew Versions that have been already been presented
    public var presentedVersions: [WhatsNew.Version] {
        .init(self.versions)
    }
    
}

// MARK: - Remove

public extension InMemoryWhatsNewVersionStore {
    
    /// Remove presented WhatsNew Version
    /// - Parameter version: The presented WhatsNew Version that should be removed
    func remove(
        presentedVersion version: WhatsNew.Version
    ) {
        self.storage.withLock { _ = $0.remove(version) }
    }
    
}

// MARK: - Remove all

public extension InMemoryWhatsNewVersionStore {
    
    /// Remove all presented WhatsNew Versions
    func removeAll() {
        self.storage.withLock { $0.removeAll() }
    }
    
}
