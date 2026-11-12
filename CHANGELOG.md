# Changelog

## 3.0.0

The first major release of Lickability's fork, based on upstream 2.2.1. Requires Xcode 26 or later and iOS 26, macOS 26, or visionOS 26. The package uses Swift 6 language mode.

### New and improved

- A native SwiftUI presentation with a compact heading, top-aligned feature icons, and a capsule Continue button. iOS and macOS use prominent glass buttons; visionOS uses its native bordered prominent style.
- Semantic typography and a primary button that grows with its content, starting at a 44-point minimum height. The primary action supports the default keyboard shortcut.
- Title-only features and optional supplemental notices, including attributed text and links. Long content and notices remain scrollable at accessibility text sizes.
- Resizable macOS sheets with an ideal starting size of 560 × 640 points.
- Native scroll bounce behavior and an action bar that reserves its own space.
- Consistent version recording when the outer sheet finishes dismissing, before the sheet's `onDismiss` callback. Secondary sheets do not mark the release notes as seen, and manual presentation preserves the presenting view's state.
- Automatic presentation can pick up release notes supplied after the view first appears, until the presentation has been dismissed.

### Breaking changes and migration

- Minimum deployment targets rise from iOS 13, macOS 11, and visionOS 1 to version 26 on all three platforms. Apps supporting earlier systems should remain on upstream 2.x.
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
