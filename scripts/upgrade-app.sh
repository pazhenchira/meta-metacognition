#!/usr/bin/env bash
# upgrade-app.sh — Pull latest .meta/ engine into a downstream app
#
# Usage:
#   # From your app directory, specify the engine repo:
#   upgrade-app.sh . https://github.com/pazhenchira/meta-metacognition.git
#   upgrade-app.sh /path/to/your-app https://github.com/user/engine.git
#
#   # Or use a local engine clone:
#   upgrade-app.sh /path/to/your-app /path/to/meta-metacognition
#
#   # Or run from within the engine repo (auto-detects):
#   /path/to/meta-metacognition/scripts/upgrade-app.sh /path/to/your-app
#
#   # Or let it read engine_source from your app's .meta-version:
#   upgrade-app.sh /path/to/your-app
#
# What it does:
#   1. Resolves the engine source (git URL, local path, or from .meta-version)
#   2. Copies the latest .meta/ folder into the target app
#   3. Updates .meta-version with new version info
#   4. Reports what changed
#
# Requirements: git, rsync (or cp on systems without rsync)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEANUP_TMPDIR=""

cleanup() {
  if [ -n "$CLEANUP_TMPDIR" ] && [ -d "$CLEANUP_TMPDIR" ]; then
    rm -rf "$CLEANUP_TMPDIR"
  fi
}
trap cleanup EXIT

# --- Argument parsing ---
APP_DIR="${1:-.}"
ENGINE_SOURCE="${2:-}"

APP_DIR="$(cd "$APP_DIR" && pwd)"

if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory '$APP_DIR' does not exist."
  exit 1
fi

# --- Resolve engine directory ---
resolve_engine_dir() {
  local source="$1"

  # Case 1: Local directory
  if [ -d "$source" ] && [ -f "$source/.meta/VERSION" ]; then
    echo "$source"
    return 0
  fi

  # Case 2: Git URL — clone to temp dir
  if [[ "$source" == http* ]] || [[ "$source" == git@* ]] || [[ "$source" == *.git ]]; then
    local tmpdir
    tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'meta-engine')
    CLEANUP_TMPDIR="$tmpdir"
    echo "Cloning engine from $source..." >&2
    git clone --depth 1 --quiet "$source" "$tmpdir" 2>&1 >&2
    if [ -f "$tmpdir/.meta/VERSION" ]; then
      echo "$tmpdir"
      return 0
    else
      echo "Error: Cloned repo does not contain .meta/VERSION" >&2
      return 1
    fi
  fi

  echo "Error: Cannot resolve engine source '$source'" >&2
  return 1
}

# Resolve ENGINE_DIR from: explicit arg > parent of script > .meta-version engine_source
ENGINE_DIR=""

if [ -n "$ENGINE_SOURCE" ]; then
  # Explicit second argument
  ENGINE_DIR=$(resolve_engine_dir "$ENGINE_SOURCE")
elif [ -f "$SCRIPT_DIR/../.meta/VERSION" ]; then
  # Script is inside engine repo
  ENGINE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [ -f "$APP_DIR/.meta-version" ]; then
  # Read engine_source from app's .meta-version
  DETECTED_SOURCE=$(grep -o '"engine_source":\s*"[^"]*"' "$APP_DIR/.meta-version" 2>/dev/null | sed 's/.*"engine_source":\s*"\([^"]*\)"/\1/' || echo "")
  if [ -n "$DETECTED_SOURCE" ]; then
    echo "Using engine_source from .meta-version: $DETECTED_SOURCE"
    ENGINE_DIR=$(resolve_engine_dir "$DETECTED_SOURCE")
  fi
fi

if [ -z "$ENGINE_DIR" ] || [ ! -f "$ENGINE_DIR/.meta/VERSION" ]; then
  echo "Error: Could not find engine. Specify it as second argument:"
  echo "  upgrade-app.sh <app-dir> <engine-repo-url-or-path>"
  echo ""
  echo "Examples:"
  echo "  upgrade-app.sh . https://github.com/pazhenchira/meta-metacognition.git"
  echo "  upgrade-app.sh . /path/to/local/meta-metacognition"
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
    ENGINE_URL="${ENGINE_SOURCE:-https://github.com/pazhenchira/meta-metacognition.git}"
    python3 -c "
import json, datetime
with open('$APP_DIR/.meta-version', 'r') as f:
    data = json.load(f)
data['meta_orchestrator_version'] = '$NEW_VERSION'
data['last_updated'] = datetime.date.today().isoformat()
data['engine_source'] = '$ENGINE_URL'
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
