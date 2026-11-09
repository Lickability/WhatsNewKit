import Foundation

/// Tracks the release notes actually shown until their outer sheet dismisses.
/// The SwiftUI modifier owns this value in State; secondary sheets never finish it.
struct WhatsNewPresentation {
    private var item: WhatsNew?
    private var versionStore: WhatsNewVersionStore?

    func eligibleItem(_ candidate: WhatsNew?, versionStore: WhatsNewVersionStore?) -> WhatsNew? {
        guard let candidate else { return nil }
        // Once presented, changing the store must not dismiss the visible sheet.
        guard item?.id == candidate.id || versionStore?.hasPresented(candidate.version) != true else {
            return nil
        }
        return candidate
    }

    mutating func didAppear(_ item: WhatsNew, versionStore: WhatsNewVersionStore?) {
        // Returning from secondary content must not replace the original store.
        guard self.item?.id != item.id else { return }
        self.item = item
        self.versionStore = versionStore
    }

    mutating func didDismiss() {
        guard let item else { return }
        let store = versionStore
        self.item = nil
        versionStore = nil
        store?.save(presentedVersion: item.version)
    }
}
