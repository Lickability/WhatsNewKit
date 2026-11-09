import XCTest
@testable import WhatsNewKit

final class WhatsNewPresentationTests: WhatsNewKitTestCase {
    func testOnlyActuallyPresentedVersionIsRecordedOnDismissal() {
        var presentation = WhatsNewPresentation()
        let store = RecordingVersionStore()
        let notes = makeWhatsNew(from: "1.0.0")
        XCTAssertNotNil(presentation.eligibleItem(notes, versionStore: store))
        presentation.didDismiss()
        XCTAssertTrue(store.saved.isEmpty)
        presentation.didAppear(notes, versionStore: store)
        XCTAssertTrue(store.saved.isEmpty)
        // SwiftUI clears its item binding before calling onDismiss.
        XCTAssertNil(presentation.eligibleItem(nil, versionStore: store))
        presentation.didDismiss()
        presentation.didDismiss()
        XCTAssertEqual(store.saved, ["1.0.0"])
    }

    func testReturningFromSecondaryContentKeepsOriginalStore() {
        var presentation = WhatsNewPresentation()
        let originalStore = RecordingVersionStore()
        let replacementStore = RecordingVersionStore()
        let notes = makeWhatsNew(from: "1.0.0")
        presentation.didAppear(notes, versionStore: originalStore)
        presentation.didAppear(notes, versionStore: replacementStore)
        XCTAssertTrue(originalStore.saved.isEmpty)
        XCTAssertTrue(replacementStore.saved.isEmpty)
        presentation.didDismiss()
        XCTAssertEqual(originalStore.saved, ["1.0.0"])
        XCTAssertTrue(replacementStore.saved.isEmpty)
    }

    func testSeenVersionsAreFilteredOnlyBeforePresentation() {
        var presentation = WhatsNewPresentation()
        let store = RecordingVersionStore()
        let notes = makeWhatsNew(from: "1.0.0")
        presentation.didAppear(notes, versionStore: store)
        store.save(presentedVersion: notes.version)
        XCTAssertNotNil(presentation.eligibleItem(notes, versionStore: store))
        presentation.didDismiss()
        XCTAssertNil(presentation.eligibleItem(notes, versionStore: store))
        XCTAssertNotNil(presentation.eligibleItem(makeWhatsNew(from: "2.0.0"), versionStore: store))
    }

    func testLaterPresentationRecordsItsOwnVersion() {
        var presentation = WhatsNewPresentation()
        let store = RecordingVersionStore()
        presentation.didAppear(makeWhatsNew(from: "1.0.0"), versionStore: store)
        presentation.didDismiss()
        presentation.didAppear(makeWhatsNew(from: "2.0.0"), versionStore: store)
        presentation.didDismiss()
        XCTAssertEqual(store.saved, ["1.0.0", "2.0.0"])
    }
}

private final class RecordingVersionStore: WhatsNewVersionStore {
    var saved: [WhatsNew.Version] = []
    var presentedVersions: [WhatsNew.Version] { saved }
    func save(presentedVersion version: WhatsNew.Version) { saved.append(version) }
}
