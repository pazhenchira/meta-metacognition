#!/usr/bin/env bash
# upgrade-app.sh — Pull latest .meta/ engine into a downstream app
#
# Usage:
#   /path/to/meta-metacognition/scripts/upgrade-app.sh /path/to/your-app
#   OR from your app directory:
#   /path/to/meta-metacognition/scripts/upgrade-app.sh .
#
# What it does:
#   1. Resolves the engine source (local clone or git remote)
#   2. Copies the latest .meta/ folder into the target app
#   3. Updates .meta-version with new version info
#   4. Reports what changed
#
# Requirements: git, rsync (or cp on systems without rsync)

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Argument parsing ---
APP_DIR="${1:-.}"
APP_DIR="$(cd "$APP_DIR" && pwd)"

if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory '$APP_DIR' does not exist."
  exit 1
fi

# --- Detect current app version ---
OLD_VERSION="unknown"
if [ -f "$APP_DIR/.meta-version" ]; then
  OLD_VERSION=$(grep -o '"meta_orchestrator_version":\s*"[^"]*"' "$APP_DIR/.meta-version" 2>/dev/null | head -1 | sed 's/.*"meta_orchestrator_version":\s*"\([^"]*\)"/\1/' || echo "unknown")
fi

NEW_VERSION=$(cat "$ENGINE_DIR/.meta/VERSION" 2>/dev/null || echo "unknown")

echo "=== Meta-Orchestrator Engine Upgrade ==="
echo "  App directory:     $APP_DIR"
echo "  Engine directory:  $ENGINE_DIR"
echo "  Current version:   $OLD_VERSION"
echo "  Target version:    $NEW_VERSION"
echo ""

if [ "$OLD_VERSION" = "$NEW_VERSION" ]; then
  echo "App is already at version $NEW_VERSION. Nothing to do."
  exit 0
fi

# --- Backup existing .meta if present ---
if [ -d "$APP_DIR/.meta" ]; then
  echo "Backing up existing .meta/ to .meta.bak/"
  rm -rf "$APP_DIR/.meta.bak"
  cp -r "$APP_DIR/.meta" "$APP_DIR/.meta.bak"
fi

# --- Copy engine .meta/ to app ---
echo "Copying .meta/ from engine to app..."
if command -v rsync &>/dev/null; then
  rsync -a --delete "$ENGINE_DIR/.meta/" "$APP_DIR/.meta/"
else
  rm -rf "$APP_DIR/.meta"
  cp -r "$ENGINE_DIR/.meta" "$APP_DIR/.meta"
fi

# --- Update .meta-version ---
if [ -f "$APP_DIR/.meta-version" ]; then
  # Update version and date in existing .meta-version
  if command -v python3 &>/dev/null; then
    python3 -c "
import json, datetime
with open('$APP_DIR/.meta-version', 'r') as f:
    data = json.load(f)
data['meta_orchestrator_version'] = '$NEW_VERSION'
data['last_updated'] = datetime.date.today().isoformat()
data['engine_source'] = 'https://github.com/pazhenchira/meta-metacognition.git'
with open('$APP_DIR/.meta-version', 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
"
  else
    # Fallback: sed-based update
    sed -i "s/\"meta_orchestrator_version\": \"[^\"]*\"/\"meta_orchestrator_version\": \"$NEW_VERSION\"/" "$APP_DIR/.meta-version"
  fi
else
  echo "No .meta-version found; copying template."
  cp "$ENGINE_DIR/.meta/templates/.meta-version.template" "$APP_DIR/.meta-version"
fi

# --- Copy lessons and status templates if app doesn't have them ---
if [ ! -f "$APP_DIR/lessons.md" ]; then
  echo "Creating lessons.md from template..."
  cp "$ENGINE_DIR/.meta/templates/lessons.template.md" "$APP_DIR/lessons.md"
fi

if [ ! -f "$APP_DIR/status.md" ]; then
  echo "Creating status.md from template..."
  cp "$ENGINE_DIR/.meta/templates/status.template.md" "$APP_DIR/status.md"
fi

# --- Summary ---
echo ""
echo "=== Upgrade Complete ==="
echo "  $OLD_VERSION → $NEW_VERSION"
echo ""
echo "Next steps:"
echo "  1. Review CHANGELOG.md in the engine repo for what changed"
echo "  2. Check UPGRADING.md for any manual steps needed"
echo "  3. Commit the changes: git add .meta/ .meta-version lessons.md status.md && git commit -m 'chore: upgrade meta-orchestrator engine to $NEW_VERSION'"
echo ""
if [ -d "$APP_DIR/.meta.bak" ]; then
  echo "  Backup saved to .meta.bak/ (safe to delete after verifying upgrade)"
fi
