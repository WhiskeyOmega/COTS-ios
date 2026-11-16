# COTS-ios — Cupoftea.social for iOS

This repo is a fork of the official Mastodon iOS app (`mastodon/mastodon-ios`), being turned into
**Cupoftea.social for iOS**: a branded app for the single Mastodon server https://cupoftea.social.

The sibling Android app is the reference for *what* to change:
https://github.com/WhiskeyOmega/Cupofteasocialapp (fork of `mastodon/mastodon-android`).
When parity matters, read it; clone read-only with:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 60 https://github.com/WhiskeyOmega/Cupofteasocialapp /home/user/whiskeyomega/cupofteasocialapp
```

## Product decisions already made (mirror the Android app)

| Item | Value |
|---|---|
| Server | `cupoftea.social` only — no server picker, no other-server login (Android commit `632f628` "Lock out other servers") |
| App name | Cupoftea.social (never "Mastodon" in user-facing name or icon — trademark, see README) |
| URL scheme | `cupoftea://` (Android uses `cupoftea://share`) |
| User agent | `CupofteaIOS/<version>` (Android: `CupofteaAndroid/<version>`) |
| Privacy policy | https://cupoftea.social/privacy-policy |
| Donate | https://ko-fi.com/cupofteasocial |
| Source link | https://github.com/WhiskeyOmega/COTS-ios |
| Signup | DOB wording changed on Android (commit `c5a865d`) — match it |
| Bundle ID | `social.cupoftea.social`; extensions `social.cupoftea.social.<ExtensionName>` (decided by user) |
| App Group | `group.social.cupoftea.social` (derived from bundle ID) |
| Keychain services | `social.cupoftea.social.keychain` (AppSecret) and `social.cupoftea.social.authentications` (AuthenticationServiceProvider), derived from bundle ID |
| Colour roles | Tint/buttons `#001839`; links `#2F5A9E` (`Brand/Link`); dark-mode tint and links `#5C8FD6`; dark fill `#2F5A9E` (lead defaults, user may override) |
| Constants | `public enum Cupoftea` in `MastodonSDK/Sources/MastodonCommon/Cupoftea.swift` (needs `import MastodonCommon`); `Mastodon.Entity.Server.cupofteaSocial` |
| Settings links | Feedback → https://github.com/WhiskeyOmega/COTS-ios/issues; Ko-fi donate row |
| Brand colour | `#001839` (main brand colour, decided by user) |
| Mascot | Tea-drinking mammoth. Asset `Scene/Welcome/cupoftea.mascot` in `MastodonAsset`; app icon layer `AppIcon.icon/Assets/cupoftea-mascot-1024.png` on a `#001839` fill |
| CI | `build-only.yml` also runs on `claude/**` branches (decided by user) |

**Still open — ask the user before changing:** push relay endpoint
(`MastodonSDK/Sources/MastodonCore/AppSecret.swift`; Mastodon's relay won't deliver to a different
bundle ID), Apple team/signing (fastlane Appfile/Matchfile), App Store listing.

## Codebase map

- `Mastodon/` — app target (UIKit + newer SwiftUI under `Mastodon/In Progress New Layout and Datamodel/`).
  Onboarding (server picker, login, register) is in `Mastodon/Scene/Onboarding/`.
- `MastodonSDK/` — local Swift package (iOS 18+): `MastodonSDK` (API client), `MastodonCore` (app logic,
  auth, `AppSecret`), `MastodonUI`, `CoreDataStack`, `MastodonAsset`, `MastodonLocalization`,
  `MastodonCommon`, `MastodonExtension`.
- Extensions: `NotificationService`, `ShareActionExtension`, `OpenInActionExtension`, `WidgetExtension`, `MastodonIntent`.
- Core Data: entities are unique by `domain` + `id`, never `id` alone. One main (UI) context, background context for writes.
- Strings: add to `MastodonSDK/Sources/MastodonLocalization/Resources/Localizable.xcstrings` and a typed
  accessor in `L10nLookup`. Never add new accessors to the swiftgen `L10n` struct. Non-English values come from Crowdin.
- Docs: `Documentation/` (Setup, How-it-works, Deployment, CONTRIBUTING).

## Build & verification reality

- **This cloud container has no Xcode or Swift toolchain.** Nothing can be compiled or run here.
  Agents must reason carefully about types/imports and say plainly that a change is unverified.
- Real verification is GitHub Actions `.github/workflows/build-only.yml` on `macos-26` / Xcode 26.2 when present (macos-15 runners stopped being assigned)
  (`bundle exec fastlane ios build_only` and `build_tests`). It triggers on pushes to `master`, `develop`,
  `feature/*`, `issue/*`, `claude/**` and PRs into `develop`.
- Never claim "builds" or "tests pass" without a CI run that shows it.

## How work is delegated (orchestration playbook)

The main session is the lead. It breaks work down, hands pieces to the subagents in `.claude/agents/`,
checks their output, and owns commits. Subagents do not commit or push.

| Agent | Use for |
|---|---|
| `ios-architect` | Read-only. Locate code, plan a change across targets/modules, Android-parity diffing. Run first on anything non-trivial. |
| `cots-brand-porter` | Rebrand + Cupoftea-specific behavior (single-server lock, names, URLs, scheme, user agent, assets). |
| `swift-ios-engineer` | General Swift/UIKit/SwiftUI feature work and bug fixes. |
| `ios-localization` | Any user-facing string change; `.xcstrings`, `L10nLookup`, InfoPlist/Widget/Intent `.strings`. |
| `ios-release-engineer` | Bundle IDs, entitlements, App Groups, xcconfig, fastlane, GitHub Actions, App Store metadata. |
| `ios-code-reviewer` | Read-only. Review every diff before commit; static compile check since we can't build. |

Typical flow: architect plans → porter/engineer implement (parallel only when files don't overlap) →
localization handles strings → reviewer checks the full diff → lead fixes findings, commits, pushes.
