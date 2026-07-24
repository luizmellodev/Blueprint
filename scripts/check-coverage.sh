#!/usr/bin/env bash
set -euo pipefail

RESULT_BUNDLE="${1:?Usage: check-coverage.sh <xcresult> [threshold_percent]}"
THRESHOLD="${2:-70}"

if [[ ! -d "$RESULT_BUNDLE" ]]; then
  echo "Result bundle not found: $RESULT_BUNDLE" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ANALYSIS=$(xcrun xccov view --report --json "$RESULT_BUNDLE" | python3 "$SCRIPT_DIR/coverage-analysis.py") || {
  echo "Failed to read coverage from result bundle: $RESULT_BUNDLE" >&2
  exit 1
}

ALL_COVERAGE=$(echo "$ANALYSIS" | sed -n 's/^ALL://p')
LOGIC_COVERAGE=$(echo "$ANALYSIS" | sed -n 's/^LOGIC://p')

echo "Blueprint line coverage (all targets): ${ALL_COVERAGE}%"
echo "Blueprint line coverage (logic layers, excl. SwiftUI Views): ${LOGIC_COVERAGE}% (minimum: ${THRESHOLD}%)"

python3 -c "
import sys
coverage = float(sys.argv[1])
threshold = float(sys.argv[2])
sys.exit(0 if coverage >= threshold else 1)
" "$LOGIC_COVERAGE" "$THRESHOLD"
