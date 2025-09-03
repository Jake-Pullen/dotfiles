#!/usr/bin/env bash
# ------------------------------------------------------------------
# download_latest_appimage.sh
#
# Usage:
#   ./download_latest_appimage.sh <owner>/<repo> [output_dir]
#
# Example:
#   ./download_latest_appimage.sh Dygmalab/Bazecor /tmp
#
# The script uses the public GitHub API (no authentication token needed for
# a single request).  If you hit rate limits, set GITHUB_TOKEN with a
# personal access token and the script will use it automatically.
# ------------------------------------------------------------------

set -euo pipefail

# ---------- Helper functions ----------
error() {
    echo "❌ $*" >&2
}
warn() {
    echo "⚠️  $*"
}

# ---------- Argument parsing ----------
# if [[ $# -lt 1 ]]; then
#     error "Missing repository argument."
#     echo "Usage: $0 <owner>/<repo> [output_dir]"
#     exit 1
# fi

REPO="Dygmalab/Bazecor"                      # e.g. Dygmalab/Bazecor
OUTDIR="$HOME/AppImages"

# Ensure output directory exists
mkdir -p "$OUTDIR"

# ---------- GitHub API ----------
API_URL="https://api.github.com/repos/${REPO}/releases/latest"
# If you have a token, uncomment the next line:
# AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

# Fetch release metadata (JSON)
echo "🔎 Querying GitHub for latest release of ${REPO}..."
RELEASE_JSON=$(curl -sSL --fail \
    "${API_URL}" \
    ${AUTH_HEADER:+-H "$AUTH_HEADER"})

# ---------- Find the AppImage asset ----------
APPIMAGE_URL=""
while IFS= read -r line; do
    # Each line is a JSON object describing an asset.
    # We look for a "name" field that ends with .AppImage (case‑insensitive)
    if [[ "$line" =~ \"name\":\ *\"([^\"]+\.AppImage)\" ]]; then
        APPIMAGE_NAME="${BASH_REMATCH[1]}"
        # The download URL is in the "browser_download_url" field.
        if [[ "$line" =~ \"browser_download_url\":\ *\"([^\"]+)\" ]]; then
            APPIMAGE_URL="${BASH_REMATCH[1]}"
            break
        fi
    fi
done < <(echo "$RELEASE_JSON" | jq -c '.assets[]')

if [[ -z $APPIMAGE_URL ]]; then
    error "No AppImage asset found in the latest release."
    exit 2
fi

echo "📥 Found AppImage: ${APPIMAGE_NAME}"
echo "🔗 Download URL: ${APPIMAGE_URL}"

# ---------- Download ----------
OUTFILE="${OUTDIR}/${APPIMAGE_NAME}"
echo "🚚 Downloading to ${OUTFILE} ..."
curl -L --fail \
    "${APPIMAGE_URL}" \
    -o "$OUTFILE"

chmod +x "$OUTFILE"
echo "✅ Done!  AppImage saved as $OUTFILE"

