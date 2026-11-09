import XCTest
@testable import WhatsNewKit

// MARK: - WhatsNewVersionStoreTests

/// The WhatsNewVersionStoreTests
final class WhatsNewVersionStoreTests: WhatsNewKitTestCase {
    
    func testInMemoryWhatsNewVersionStore() {
        let inMemoryWhatsNewVersionStore = InMemoryWhatsNewVersionStore()
        let version = self.executeVersionStoreTest(inMemoryWhatsNewVersionStore)
        XCTAssertEqual(
            [version],
            inMemoryWhatsNewVersionStore.versions
        )
        inMemoryWhatsNewVersionStore.removeAll()
        XCTAssert(
            inMemoryWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            inMemoryWhatsNewVersionStore.versions.isEmpty
        )
    }
    
    func testConcurrentInMemorySavesDoNotLoseVersions() {
        let store = InMemoryWhatsNewVersionStore()
        DispatchQueue.concurrentPerform(iterations: 1_000) { index in
            store.save(presentedVersion: .init(major: index, minor: 0, patch: 0))
        }
        let expected = Set((0..<1_000).map {
            WhatsNew.Version(major: $0, minor: 0, patch: 0)
        })
        XCTAssertEqual(store.versions, expected)

        DispatchQueue.concurrentPerform(iterations: 500) { index in
            store.remove(presentedVersion: .init(major: index, minor: 0, patch: 0))
        }
        XCTAssertEqual(store.versions, expected.filter { $0.major >= 500 })
    }

    func testInMemoryVersionSnapshotsAndReplacement() {
        let store = InMemoryWhatsNewVersionStore()
        store.versions = ["1.0.0"]
        let snapshot = store.versions
        store.save(presentedVersion: "2.0.0")
        XCTAssertEqual(snapshot, ["1.0.0"])
        XCTAssertEqual(store.versions, ["1.0.0", "2.0.0"])
        store.versions = ["3.0.0"]
        XCTAssertEqual(store.presentedVersions, ["3.0.0"])
    }

    func testUserDefaultsWhatsNewVersionStore() {
        final class FakeUserDefaults: UserDefaults {
            var store: [String: Any] = .init()
            
            override func set(_ value: Any?, forKey defaultName: String) {
                self.store[defaultName] = value
            }
            
            override func dictionaryRepresentation() -> [String: Any] {
                self.store
            }
        }
        let fakeUserDefaults = FakeUserDefaults()
        let userDefaultsWhatsNewVersionStore = UserDefaultsWhatsNewVersionStore(
            userDefaults: fakeUserDefaults
        )
        let version = self.executeVersionStoreTest(userDefaultsWhatsNewVersionStore)
        XCTAssertEqual(
            fakeUserDefaults.store.count,
            1
        )
        XCTAssertEqual(
            version,
            (fakeUserDefaults.store[version.key] as? String).flatMap(WhatsNew.Version.init)
        )
        userDefaultsWhatsNewVersionStore.removeAll()
        XCTAssert(
            userDefaultsWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            fakeUserDefaults.store.isEmpty
        )
    }
    
    func testNSUbiquitousKeyValueWhatsNewVersionStore() {
        final class FakeNSUbiquitousKeyValueStore: NSUbiquitousKeyValueStore {
            var store: [String: Any] = .init()
            
            override var dictionaryRepresentation: [String: Any] {
                self.store
            }
            
            override func set(_ value: Any?, forKey defaultName: String) {
                self.store[defaultName] = value
            }
            
            override func removeObject(forKey aKey: String) {
                self.store.removeValue(forKey: aKey)
            }
        }
        let fakeNSUbiquitousKeyValueStore = FakeNSUbiquitousKeyValueStore()
        let ubiquitousKeyValueWhatsNewVersionStore = NSUbiquitousKeyValueWhatsNewVersionStore(
            ubiquitousKeyValueStore: fakeNSUbiquitousKeyValueStore
        )
        let version = self.executeVersionStoreTest(ubiquitousKeyValueWhatsNewVersionStore)
        XCTAssertEqual(
            fakeNSUbiquitousKeyValueStore.store.count,
            1
        )
        XCTAssertEqual(
            version,
            (fakeNSUbiquitousKeyValueStore.store[version.key] as? String).flatMap(WhatsNew.Version.init)
        )
        ubiquitousKeyValueWhatsNewVersionStore.removeAll()
        XCTAssert(
            ubiquitousKeyValueWhatsNewVersionStore.presentedVersions.isEmpty
        )
        XCTAssert(
            fakeNSUbiquitousKeyValueStore.store.isEmpty
        )
    }
    
}

private extension WhatsNewVersionStoreTests {
    
    func executeVersionStoreTest(
        _ versionStore: WhatsNewVersionStore
    ) -> WhatsNew.Version {
        let version = self.makeRandomWhatsNewVersion()
        XCTAssert(versionStore.presentedVersions.isEmpty)
        XCTAssertFalse(versionStore.hasPresented(version))
        versionStore.save(
            presentedVersion: version
        )
        XCTAssertEqual([version], versionStore.presentedVersions)
        XCTAssert(versionStore.hasPresented(version))
        return version
    }
    
}
