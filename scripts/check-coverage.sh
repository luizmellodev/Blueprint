#!/usr/bin/env bash
set -euo pipefail

RESULT_BUNDLE="${1:?Usage: check-coverage.sh <xcresult> [threshold_percent]}"
THRESHOLD="${2:-70}"

if [[ ! -d "$RESULT_BUNDLE" ]]; then
  echo "Result bundle not found: $RESULT_BUNDLE" >&2
  exit 1
fi

COVERAGE=$(xcrun xccov view --report --json "$RESULT_BUNDLE" | python3 -c "
import json, sys

data = json.load(sys.stdin)
targets = data.get('targets', [])

def is_app_target(name: str) -> bool:
    lowered = name.lower()
    if 'test' in lowered:
        return False
    return lowered in ('blueprint.app', 'blueprint') or lowered.endswith('blueprint.app')

app = next((t for t in targets if is_app_target(t.get('name', ''))), None)
if app is None:
    print('ERROR: blueprint app target not found in coverage report', file=sys.stderr)
    sys.exit(1)

print(f\"{app['lineCoverage'] * 100:.2f}\")
")

echo "Blueprint line coverage: ${COVERAGE}% (minimum: ${THRESHOLD}%)"

python3 -c "
import sys
coverage = float(sys.argv[1])
threshold = float(sys.argv[2])
sys.exit(0 if coverage >= threshold else 1)
" "$COVERAGE" "$THRESHOLD"
