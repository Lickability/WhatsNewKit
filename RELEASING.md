# Releasing

Releases are published from [Lickability/WhatsNewKit](https://github.com/Lickability/WhatsNewKit). Swift Package Manager uses Git tags as package versions; there is no separate framework version field in `Package.swift`. The example app's version is independent.

## Prepare 3.0.0

1. Review and merge the release preparation PR, including the [release notes](CHANGELOG.md#300) and installation instructions.
2. Verify that **Build and Test** and **Build Example Project** passed for the framework changes being released. Documentation-only changes do not trigger those workflows; run them manually on the release commit if needed.
3. Fetch `main`, confirm the exact commit to release, and verify that no `3.0.0` tag or release already exists on the fork. Check the working tree before creating a tag.

## Publish after merge

Run these commands from a checkout of the fork, after reviewing the commit selected by `origin/main`:

```sh
git fetch origin main
git show --stat origin/main
git ls-remote --tags origin refs/tags/3.0.0
gh release view 3.0.0 --repo Lickability/WhatsNewKit
```

For the first release, the tag lookup should be empty and the release lookup should report that the release does not exist. Resolve authentication or network errors before proceeding.

Copy the 3.0.0 section of `CHANGELOG.md` into a release-notes file, using absolute GitHub URLs for its README links. Then create an annotated tag at the reviewed commit and publish the release:

```sh
git tag -a 3.0.0 <reviewed-commit-sha> -m "WhatsNewKit 3.0.0"
git push origin refs/tags/3.0.0
gh release create 3.0.0 --repo Lickability/WhatsNewKit --verify-tag --title "WhatsNewKit 3.0.0" --notes-file /path/to/release-notes.md --latest
```

Do not move or overwrite a published version tag. Merging the preparation PR does not create a tag or publish a release.

## Verify

- Check that the remote `3.0.0` tag resolves to the reviewed commit and the GitHub release is published, not a draft or prerelease.
- Resolve `https://github.com/Lickability/WhatsNewKit.git` at `3.0.0` from a fresh Swift Package Manager consumer and confirm it builds on a supported platform.
- Check the release notes and installation links on GitHub. Documentation hosting is configured separately from package releases.
