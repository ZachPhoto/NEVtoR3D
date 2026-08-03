#!/bin/bash
# NEVtoR3D 卸载脚本（macOS）
set -euo pipefail

DEST="$HOME/Library/Services/NEVtoR3D.workflow"

if [ -d "$DEST" ]; then
  rm -rf "$DEST"
  echo "==> 已删除 $DEST"
else
  echo "服务未安装，无需删除。"
fi

echo "==> 移除快捷键配置 ..."
python3 - <<'PYEOF' 2>/dev/null || true
import plistlib, pathlib
p = pathlib.Path.home() / "Library/Preferences/pbs.plist"
if p.exists():
    d = plistlib.loads(p.read_bytes())
    s = d.get("NSServicesStatus", {})
    s.pop("com.apple.Automator.NEVtoR3D - NEV转R3D - runWorkflowAsService", None)
    d["NSServicesStatus"] = s
    p.write_bytes(plistlib.dumps(d, fmt=plistlib.FMT_XML, sort_keys=False))
    print("快捷键配置已移除")
PYEOF

/System/Library/CoreServices/pbs -flush 2>/dev/null || true
killall cfprefsd 2>/dev/null || true
killall Finder 2>/dev/null || true

echo ""
echo "✅ 卸载完成。运行日志 ~/Library/Logs/NEVtoR3D.log 已保留，不需要可手动删除。"
