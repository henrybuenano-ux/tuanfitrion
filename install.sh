#!/usr/bin/env bash
#
# install.sh — set up the `ghl` GoHighLevel CLI.
#
#   * verifies python3 is available
#   * makes ./ghl executable
#   * writes ./.ghl/config.json with your credentials
#   * (optionally) symlinks `ghl` onto your PATH
#
# Credentials are read from environment variables when present, otherwise you
# are prompted interactively:
#
#   GHL_TOKEN        Bearer token — a Private Integration Token (pit-...) or
#                    an OAuth access token. (GHL_PIT is accepted as an alias.)
#   GHL_LOCATION_ID  GoHighLevel Location ID.
#   GHL_OAUTH_TOKEN  (optional) a secondary OAuth token, stored for reference.
#
# The config file lives next to this script and is git-ignored — secrets are
# never committed.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CONFIG_DIR="$SCRIPT_DIR/.ghl"
CONFIG_FILE="$CONFIG_DIR/config.json"

say()  { printf '%s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }

say "Installing the ghl CLI…"

# --- 1. dependencies ------------------------------------------------------- #
if ! command -v python3 >/dev/null 2>&1; then
  echo "install.sh: error: python3 is required but was not found on PATH." >&2
  exit 1
fi
ok "python3 found: $(python3 --version 2>&1)"

# --- 2. make the launcher executable --------------------------------------- #
chmod +x "$SCRIPT_DIR/ghl"
ok "made ./ghl executable"

# --- 3. gather credentials ------------------------------------------------- #
TOKEN="${GHL_TOKEN:-${GHL_PIT:-}}"
LOCATION="${GHL_LOCATION_ID:-}"
OAUTH_TOKEN="${GHL_OAUTH_TOKEN:-}"

if [ -z "$TOKEN" ]; then
  if [ -t 0 ]; then
    read -r -p "GoHighLevel token (pit-... or OAuth access token): " TOKEN
  else
    echo "install.sh: error: no token provided. Set GHL_TOKEN (or GHL_PIT) and re-run." >&2
    exit 1
  fi
fi

if [ -z "$LOCATION" ]; then
  if [ -t 0 ]; then
    read -r -p "GoHighLevel Location ID: " LOCATION
  else
    warn "no Location ID provided (GHL_LOCATION_ID); you can pass --location later."
  fi
fi

# --- 4. write the config file ---------------------------------------------- #
mkdir -p "$CONFIG_DIR"
TOKEN="$TOKEN" LOCATION="$LOCATION" OAUTH_TOKEN="$OAUTH_TOKEN" \
  python3 - "$CONFIG_FILE" <<'PY'
import json, os, sys
path = sys.argv[1]
cfg = {"token": os.environ["TOKEN"]}
if os.environ.get("LOCATION"):
    cfg["location_id"] = os.environ["LOCATION"]
if os.environ.get("OAUTH_TOKEN"):
    cfg["oauth_token"] = os.environ["OAUTH_TOKEN"]
with open(path, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=2)
    fh.write("\n")
PY
chmod 600 "$CONFIG_FILE"
ok "wrote config to ${CONFIG_FILE#$SCRIPT_DIR/} (chmod 600, git-ignored)"

# --- 5. optional: symlink onto PATH ---------------------------------------- #
for BIN_DIR in "$HOME/.local/bin" "/usr/local/bin"; do
  if [ -d "$BIN_DIR" ] && [ -w "$BIN_DIR" ]; then
    ln -sf "$SCRIPT_DIR/ghl" "$BIN_DIR/ghl" && ok "linked ghl → $BIN_DIR/ghl"
    break
  fi
done

say ""
say "Done. Try:"
say "  ./ghl contacts list --limit 5"
say "  ./ghl workflows list"
