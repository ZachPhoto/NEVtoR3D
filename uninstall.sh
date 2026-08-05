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
PLIST="$HOME/Library/Preferences/pbs.plist"
KEY="com.apple.Automator.NEVtoR3D - NEV转R3D - runWorkflowAsService" # 与 install.sh 中的 KEY 保持一致
if [ -f "$PLIST" ]; then
  /usr/libexec/PlistBuddy -c "Delete :NSServicesStatus:$KEY" "$PLIST" >/dev/null 2>&1 && \
    echo "快捷键配置已移除" || true
fi

/System/Library/CoreServices/pbs -flush 2>/dev/null || true
killall cfprefsd 2>/dev/null || true
killall Finder 2>/dev/null || true

echo ""
echo "✅ 卸载完成。运行日志 ~/Library/Logs/NEVtoR3D.log 已保留，不需要可手动删除。"
