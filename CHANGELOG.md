# Changelog

## 3.0.0

The first major release of Lickability's fork, based on upstream 2.2.1. Requires Xcode 26 or later and iOS 26, macOS 26, or visionOS 26. The package uses Swift 6 language mode.

### New and improved

- A native SwiftUI presentation with a compact heading, top-aligned feature icons, and a capsule Continue button.
- Feature bullets can now have a title without a subtitle.
- Versions are marked as seen after the release notes are dismissed.

### Breaking changes and migration

- Minimum deployment targets are updated from iOS 13, macOS 11, and visionOS 1 to version 26 on all three platforms. Apps supporting earlier systems should remain on upstream 2.x.
- Replace `PrimaryAction(backgroundColor:foregroundColor:)` and those properties with `PrimaryAction(tint:)` and `tint`. The native button style controls the foreground and shape.
- Replace `Layout.featureListPadding` with `contentPadding` and `footerVisualEffectViewPadding` with `footerPadding`. Remove `scrollViewBottomContentInset`, `featureHorizontalAlignment`, and `footerPrimaryActionButtonCornerRadius`; the native layout handles these behaviors. Review custom spacing against the new defaults.
- `Feature.subtitle` is now optional. Unwrap it when reading it; omit it or pass nil or empty text for a title-only feature.
- `WhatsNew.Layout.default` is immutable. Customize a local copy and pass it to a view or `WhatsNewEnvironment(defaultLayout:)`.
- `WhatsNewEnvironment.Key.defaultValue` is read-only and returns an independent environment. Supply a custom environment with `.environment(\.whatsNew, yourEnvironment)`.
- Views, UI callbacks, feature image builders, haptic execution, and `InMemoryWhatsNewVersionStore.shared` require main-actor access. Custom version stores remain synchronous and do not need `Sendable` conformance.
- Handle the new `SecondaryAction.Action.perform`, `.dismiss`, and `.openURL` cases in exhaustive switches. Migrate deprecated `.custom` callbacks to `.perform { dismiss in ... }` and call `dismiss()` instead of `presentationMode.wrappedValue.dismiss()`. URL actions now use SwiftUI's `openURL` environment action.

`PrimaryAction.onDismiss` still runs when Continue requests dismissal. Use the sheet modifier's `onDismiss` callback for work that must wait until dismissal completes.

See the README for [Swift 6 migration](README.md#swift-6-migration), [presentation lifecycle](README.md#presentation-lifecycle), and [layout migration](README.md#migrating-from-the-previous-design).

### Installation

Replace the upstream dependency with Lickability's fork:

```swift
.package(url: "https://github.com/Lickability/WhatsNewKit.git", from: "3.0.0")
```

The product name and `import WhatsNewKit` are unchanged. Version 3.0.0 becomes available through Swift Package Manager when its Git tag is published.
