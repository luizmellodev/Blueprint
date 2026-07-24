import json
import sys


def is_app_target(name: str) -> bool:
    lowered = name.lower()
    if "test" in lowered:
        return False
    return lowered in ("blueprint.app", "blueprint") or lowered.endswith("blueprint.app")


def counts_toward_logic_threshold(path: str) -> bool:
    if "ViewModel" in path:
        return True
    if path.endswith("View.swift"):
        return False
    if "AppRouterView.swift" in path:
        return False
    if "/Components/" in path:
        return False
    return True


data = json.load(sys.stdin)
app = next(t for t in data["targets"] if is_app_target(t.get("name", "")))

all_executable = app.get("executableLines", 0)
all_covered = app.get("coveredLines", 0)
all_pct = app.get("lineCoverage", 0) * 100

logic_executable = 0
logic_covered = 0
for file in app.get("files", []):
    path = file.get("name", "")
    if not counts_toward_logic_threshold(path):
        continue
    executable = file.get("executableLines", 0)
    covered = file.get("coveredLines", 0)
    logic_executable += executable
    logic_covered += covered

logic_pct = (logic_covered / logic_executable * 100) if logic_executable else 0

print(f"ALL:{all_pct:.2f}")
print(f"LOGIC:{logic_pct:.2f}")
