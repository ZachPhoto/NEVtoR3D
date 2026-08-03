#!/bin/bash
# NEVtoR3D 一键安装脚本（macOS）
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/NEVtoR3D.workflow"
DEST="$HOME/Library/Services/NEVtoR3D.workflow"

if [ ! -d "$SRC" ]; then
  echo "错误：找不到 NEVtoR3D.workflow，请确认本脚本与 NEVtoR3D.workflow 在同一目录。"
  exit 1
fi

echo "==> 安装服务到 ~/Library/Services ..."
mkdir -p "$HOME/Library/Services"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"

echo "==> 刷新系统服务注册 ..."
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
killall Finder 2>/dev/null || true

echo ""
read -r -p "是否设置默认快捷键 ⌃⌥⌘R（选中文件后一键转换）？(y/N) " ans
if [[ "${ans:-}" =~ ^[Yy]$ ]]; then
  python3 - <<'PYEOF'
import plistlib, pathlib
p = pathlib.Path.home() / "Library/Preferences/pbs.plist"
d = plistlib.loads(p.read_bytes()) if p.exists() else {}
s = d.get("NSServicesStatus", {})
s["com.apple.Automator.NEVtoR3D - NEV转R3D - runWorkflowAsService"] = {
    "enabled_menu": 1,
    "enabled_context_menu": 1,
    "key_equivalent": "^~@r",
}
d["NSServicesStatus"] = s
p.write_bytes(plistlib.dumps(d, fmt=plistlib.FMT_XML, sort_keys=False))
print("快捷键 ⌃⌥⌘R 已写入")
PYEOF
  killall cfprefsd 2>/dev/null || true
  /System/Library/CoreServices/pbs -flush 2>/dev/null || true
fi

echo ""
echo "✅ 安装完成！"
echo ""
echo "使用方法："
echo "  1. 在访达中选中 .nev 素材文件"
echo "  2. 右键 → 服务 → NEV转R3D（或按 ⌃⌥⌘R）"
echo ""
echo "提示："
echo "  - 若右键菜单暂时看不到服务，再执行一次："
echo "    /System/Library/CoreServices/pbs -flush && killall Finder"
echo "  - 建议在 系统设置 → 通知 中允许「Script Editor」通知，否则转换完成不弹横幅"
echo "  - 运行日志位于 ~/Library/Logs/NEVtoR3D.log"
