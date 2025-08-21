#!/usr/bin/env bash
set -euo pipefail

DMG_URL="https://secure.backblaze.com/mac/install_backblaze.dmg"
DMG_PATH="/tmp/backblaze_latest.dmg"
CHECK_PATHS=(
  "/Applications/Backblaze.app"
  "/Library/Backblaze.bzpkg"
  "/Library/LaunchDaemons/com.backblaze.bzserv.plist"
)

is_installed=false
for p in "${CHECK_PATHS[@]}"; do
  [[ -e "$p" ]] && { is_installed=true; break; }
done

if [[ $is_installed == false ]]; then
  echo "Backblaze is not installed. Nothing to do."
  exit 0
fi
echo "Backblaze detected – proceeding with removal …"

echo "Downloading newest Backblaze installer …"
if ! curl -L --fail -o "$DMG_PATH" "$DMG_URL"; then
  echo "Failed to download Backblaze DMG."
  exit 1
fi

if ! hdiutil imageinfo "$DMG_PATH" >/dev/null 2>&1; then
  echo "Downloaded file is not a valid DMG."
  rm -f "$DMG_PATH"
  exit 1
fi

echo "Mounting DMG …"
ATTACH_OUTPUT=$(hdiutil attach "$DMG_PATH" -nobrowse)
VOL=$(echo "$ATTACH_OUTPUT" | grep -oE '/Volumes/.*')
if [[ -z "$VOL" || ! -d "$VOL" ]]; then
  echo "Failed to mount DMG."
  exit 1
fi

UNINSTALLER="$VOL/Backblaze Installer.app/Contents/MacOS/bzinstall_mate"
if [[ ! -x "$UNINSTALLER" ]]; then
  echo "Uninstaller not found at expected path: $UNINSTALLER"
  hdiutil detach "$VOL" -quiet
  exit 1
fi

echo "Running silent uninstaller …"
sudo "$UNINSTALLER" --uninstall

echo "Detaching DMG …"
hdiutil detach "$VOL" -quiet
rm -f "$DMG_PATH"

leftovers=0
for p in "${CHECK_PATHS[@]}"; do
  [[ -e "$p" ]] && leftovers=$((leftovers+1))
done
launchctl list | grep -q "com.backblaze" && leftovers=$((leftovers+1))

if [[ $leftovers -eq 0 ]]; then
  echo "Backblaze successfully removed."
  exit 0
else
  echo "Backblaze appears to have leftovers. Manual cleanup may be required."
  exit 2
fi