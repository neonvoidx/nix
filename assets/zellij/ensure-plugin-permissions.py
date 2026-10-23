"""Restore zj-which-key's grants before launch without replacing other entries.

Zellij 0.45 caches the popup's smaller permission request over the controller's
request for the same WASM path. This handles the generated permissions.kdl
format and keeps existing grants and unrelated plugin entries intact.
"""
import json
import os
from pathlib import Path
import re
import sys
import tempfile


def ensure_permissions(cache, plugin):
    cache = Path(cache)
    required = ["ReadApplicationState", "ChangeApplicationState", "MessageAndLaunchOtherPlugins"]
    original = cache.read_text() if cache.exists() else ""
    quoted = json.dumps(str(plugin), ensure_ascii=False)
    pattern = re.compile(r"(?m)^[ \t]*" + re.escape(quoted) + r"[ \t]*\{([^{}]*)\}")
    found = False

    def update(match):
        nonlocal found
        found = True
        existing = set(re.findall(r"(?m)^\s*(\w+)\s*;?\s*$", match.group(1)))
        missing = [grant for grant in required if grant not in existing]
        if not missing:
            return match.group(0)
        return match.group(0)[:-1].rstrip() + "\n" + "".join("    " + grant + "\n" for grant in missing) + "}"

    updated = pattern.sub(update, original)
    if not found:
        updated = original.rstrip() + "\n" + quoted + " {\n" + "".join("    " + grant + "\n" for grant in required) + "}\n"
    if updated == original:
        return
    cache.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary = tempfile.mkstemp(prefix=".which-key-permissions-", dir=cache.parent)
    try:
        with os.fdopen(descriptor, "w") as output:
            output.write(updated)
        if cache.exists():
            os.chmod(temporary, cache.stat().st_mode & 0o777)
        os.replace(temporary, cache)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


if __name__ == "__main__":
    ensure_permissions(sys.argv[1], sys.argv[2])
