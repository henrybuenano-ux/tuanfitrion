# ghl — GoHighLevel CLI

A small, dependency-free command-line client for the
[GoHighLevel / LeadConnector API v2](https://highlevel.stitch.sh/) (`services.leadconnectorhq.com`).

## Install

```bash
./install.sh
```

The installer verifies `python3`, makes `./ghl` executable, and writes your
credentials to `./.ghl/config.json` (git-ignored, `chmod 600`).

Provide credentials via environment variables (recommended for non-interactive
use) or answer the prompts:

```bash
GHL_TOKEN="pit-xxxxxxxx-...." \
GHL_LOCATION_ID="YourLocationId" \
  ./install.sh
```

| Variable          | Meaning                                                              |
| ----------------- | ------------------------------------------------------------------- |
| `GHL_TOKEN`       | Bearer token — a Private Integration Token (`pit-...`) or OAuth one. |
| `GHL_PIT`         | Alias for `GHL_TOKEN`.                                               |
| `GHL_LOCATION_ID` | GoHighLevel Location ID.                                             |
| `GHL_OAUTH_TOKEN` | Optional secondary OAuth token, stored for reference.               |

## Usage

```bash
./ghl contacts list --limit 5      # list contacts
./ghl contacts list --query jane   # search contacts
./ghl contacts get <contactId>     # fetch one contact (raw JSON)
./ghl workflows list               # list workflows
./ghl config show                  # show resolved config (token redacted)
```

Global flags (override config/env): `--token`, `--location`, `--json`.

```bash
./ghl workflows list --json        # raw JSON instead of a table
./ghl contacts list --location YourLocationId --limit 10
```

## How credentials are resolved

In priority order:

1. command-line flags — `--token`, `--location`
2. config file — `./.ghl/config.json`, then `~/.config/ghl/config.json`
3. environment variables — `GHL_TOKEN`, `GHL_LOCATION_ID`

The config file written by `install.sh` deliberately wins over environment
variables: a Private Integration Token (`pit-...`) is bound to a single
location, so an ambient `GHL_LOCATION_ID` from a different account must not
silently override the matched pair the installer saved. Environment variables
still apply when a field is missing from the config file (e.g. CI with no
config file). Use `--location` to switch locations at runtime.

## Notes

- Requires **Python 3** only (standard library — no `pip install` needed).
- All requests send the `Version: 2021-07-28` header required by the v2 API.
- The CLI needs outbound network access to `services.leadconnectorhq.com`.
