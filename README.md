# Scoville Splice Desktop

Native macOS wrapper for [scovillesplice.farm](https://www.scovillesplice.farm), built with [Tauri v2](https://tauri.app).

## What it does

Loads the live Scoville Splice platform in a native macOS window with:
- **System tray** — quick access without keeping a Dock icon
- **Hide on close** (⌘W hides; tray icon reopens)
- **Auto-updater** — checks for new releases silently on launch
- **Native title bar overlay** — clean borderless chrome on macOS

## Prerequisites

- macOS 12+
- Rust (Homebrew: `brew install rust`)
- Node.js 18+

## Local development (unsigned)

```bash
cd desktop
npm install
npm run dev        # opens a window loading the live site
```

## Build a .dmg

```bash
./build-dmg.sh
# Unsigned test build:
#   src-tauri/target/release/bundle/dmg/Scoville Splice_0.1.0_aarch64.dmg

# Signed + notarized (set env vars first):
APPLE_SIGNING_IDENTITY="Developer ID Application: ..." \
APPLE_ID="you@apple.com" \
APPLE_PASSWORD="xxxx-xxxx-xxxx-xxxx" \
APPLE_TEAM_ID="XXXXXXXXXX" \
./build-dmg.sh
```

## Code signing setup

1. Export your **Developer ID Application** certificate from Keychain as a `.p12` file.
2. Base64-encode it: `base64 -i cert.p12 | pbcopy`
3. Add to GitHub Actions secrets:
   - `APPLE_CERTIFICATE` — base64 p12
   - `APPLE_CERTIFICATE_PASSWORD` — p12 password
   - `APPLE_SIGNING_IDENTITY` — full "Developer ID Application: …" string
   - `APPLE_ID` — Apple ID email
   - `APPLE_PASSWORD` — App-specific password from appleid.apple.com
   - `APPLE_TEAM_ID` — 10-character team ID
   - `TAURI_SIGNING_PRIVATE_KEY` — `tauri signer generate` output (for updater)
   - `TAURI_SIGNING_PRIVATE_KEY_PASSWORD`

## Auto-updater

The app checks `https://www.scovillesplice.farm/api/desktop/update/{target}/{arch}/{current_version}` on launch. When a new version ships:
1. Update `LATEST_VERSION` in `site/src/app/api/desktop/update/[target]/[arch]/[version]/route.ts`
2. Add the `.dmg` download URL and Tauri updater signature for each arch

## Distributing the .dmg

Upload the signed .dmg to a GitHub release tagged `desktop-v{version}`. Users download it from the site's `/download` page.

## App icons

Icons must be placed in `src-tauri/icons/` in these sizes:
- `32x32.png`, `128x128.png`, `128x128@2x.png`
- `icon.icns` (macOS)
- `icon.ico` (Windows, future)
- `tray-icon.png` (16×16 or 32×32, template-style dark/light)

Generate from a master 1024×1024 PNG using `tauri icon path/to/icon.png`.
