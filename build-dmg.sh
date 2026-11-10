#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# Scoville Splice Desktop — macOS .dmg build script
#
# Required env vars for signed + notarized builds:
#   APPLE_SIGNING_IDENTITY   "Developer ID Application: Your Name (XXXXXXXXXX)"
#   APPLE_ID                 your@apple.id
#   APPLE_PASSWORD           app-specific password (xcrun notarytool)
#   APPLE_TEAM_ID            10-character team ID
#
# For an unsigned local test build, leave those unset.
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

cd "$(dirname "$0")"

echo "▶ Installing npm deps…"
npm install

if [ -n "${APPLE_SIGNING_IDENTITY:-}" ]; then
  echo "▶ Building signed + notarized .dmg (this takes a few minutes)…"
  TAURI_SIGNING_PRIVATE_KEY="${TAURI_SIGNING_PRIVATE_KEY:-}" \
  TAURI_SIGNING_PRIVATE_KEY_PASSWORD="${TAURI_SIGNING_PRIVATE_KEY_PASSWORD:-}" \
  npm run build:dmg \
    -- \
    --config "src-tauri/tauri.conf.json" \
    -- \
    --env APPLE_SIGNING_IDENTITY="$APPLE_SIGNING_IDENTITY" \
    --env APPLE_ID="$APPLE_ID" \
    --env APPLE_PASSWORD="$APPLE_PASSWORD" \
    --env APPLE_TEAM_ID="$APPLE_TEAM_ID"
else
  echo "▶ Building unsigned .dmg for local testing…"
  npm run build:dmg
fi

DMG=$(find src-tauri/target/release/bundle/dmg -name "*.dmg" 2>/dev/null | head -1)
if [ -n "$DMG" ]; then
  echo "✅ Built: $DMG"
  echo "   Size: $(du -sh "$DMG" | cut -f1)"
else
  echo "⚠ DMG not found in expected location; check src-tauri/target/release/bundle/"
fi
