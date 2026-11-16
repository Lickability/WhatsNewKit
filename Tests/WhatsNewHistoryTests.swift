import Foundation
import XCTest
@testable import WhatsNewKit

final class WhatsNewHistoryTests: XCTestCase {
    func testCurrentReleaseUsesBundleMarketingVersionAndBuild() {
        let release = WhatsNew(title: "What’s New", features: [])
        XCTAssertEqual(release.version, .current())
        XCTAssertEqual(release.buildNumber, Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)
    }

    func testExplicitHistoricalReleaseDoesNotInheritCurrentBuild() {
        let release = WhatsNew(version: "1.2.3", title: "What’s New", features: [])
        XCTAssertNil(release.buildNumber)
        XCTAssertEqual(release.historyVersionTitle, "1.2.3")
    }

    func testHistoryHeadingIncludesMarketingVersionAndBuild() {
        let release = WhatsNew(version: "1.2.3", buildNumber: "456", title: "What’s New", features: [])
        XCTAssertEqual(release.historyVersionTitle, "1.2.3 (456)")
    }

    func testHistoryHeadingPreservesBuildNumberFormatting() {
        let release = WhatsNew(version: "1.2.3", buildNumber: "00456.2", title: "What’s New", features: [])
        XCTAssertEqual(release.historyVersionTitle, "1.2.3 (00456.2)")
    }

    func testHistoryHeadingOmitsEmptyBuildNumbers() {
        for buildNumber in ["", "  ", "\n"] {
            let release = WhatsNew(version: "1.2.3", buildNumber: buildNumber, title: "What’s New", features: [])
            XCTAssertEqual(release.historyVersionTitle, "1.2.3")
        }
    }

    func testBuildNumberDoesNotChangeLaunchPresentationIdentity() {
        let first = WhatsNew(version: "1.2.3", buildNumber: "456", title: "What’s New", features: [])
        let second = WhatsNew(version: "1.2.3", buildNumber: "457", title: "What’s New", features: [])
        XCTAssertEqual(first.id, second.id)
        XCTAssertNotEqual(first.historyVersionTitle, second.historyVersionTitle)
    }
}
