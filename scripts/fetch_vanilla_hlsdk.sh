#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/external/hlsdk-portable"
rm -rf "$DEST"
mkdir -p "$ROOT/external"
git clone --depth 1 https://github.com/FWGS/hlsdk-portable.git "$DEST"
# The vanilla Half-Life game libraries are linked statically into the iOS binary.
python3 - "$DEST/dlls/CMakeLists.txt" "$DEST/cl_dll/CMakeLists.txt" <<'PY'
import pathlib, sys
for name in sys.argv[1:]:
    p=pathlib.Path(name)
    s=p.read_text()
    s=s.replace('add_library (${SVDLL_LIBRARY} SHARED', 'add_library (${SVDLL_LIBRARY} STATIC')
    s=s.replace('add_library (${CLDLL_LIBRARY} SHARED', 'add_library (${CLDLL_LIBRARY} STATIC')
    p.write_text(s)
PY
echo "Vanilla HLSDK ready at $DEST"
