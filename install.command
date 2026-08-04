#!/bin/bash
# NEVtoR3D 双击安装器 —— 下载解压后双击本文件即可，无需打开终端
cd "$(dirname "$0")" || exit 1
clear

echo "======================================"
echo "   NEVtoR3D 一键安装"
echo "   尼康 N-RAW (.nev) → .R3D 右键服务"
echo "======================================"
echo ""

SRC="NEVtoR3D.workflow"
DEST="$HOME/Library/Services/NEVtoR3D.workflow"

if [ ! -d "$SRC" ]; then
  echo "❌ 找不到 NEVtoR3D.workflow"
  echo ""
  echo "请确认本文件和 NEVtoR3D.workflow 在同一个文件夹里，"
  echo "不要单独把安装器拖出来运行。"
  echo ""
  read -r -p "按回车键关闭窗口..."
  exit 1
fi

echo "① 安装服务到 系统资源库/Services ..."
mkdir -p "$HOME/Library/Services"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"

echo "② 刷新系统服务注册 ..."
/System/Library/CoreServices/pbs -flush 2>/dev/null
killall Finder 2>/dev/null

echo "③ 设置默认快捷键 ⌃⌥⌘R ..."
PLIST="$HOME/Library/Preferences/pbs.plist"
PB=/usr/libexec/PlistBuddy
KEY="com.apple.Automator.NEVtoR3D - NEV转R3D - runWorkflowAsService"
if [ ! -f "$PLIST" ]; then
  printf '<?xml version="1.0" encoding="UTF-8"?><plist version="1.0"><dict/></plist>' > "$PLIST"
fi
"$PB" -c "Print :NSServicesStatus" "$PLIST" >/dev/null 2>&1 || \
  "$PB" -c "Add :NSServicesStatus dict" "$PLIST" >/dev/null 2>&1
"$PB" -c "Delete :NSServicesStatus:$KEY" "$PLIST" >/dev/null 2>&1
"$PB" -c "Add :NSServicesStatus:$KEY dict" "$PLIST" >/dev/null 2>&1
"$PB" -c "Add :NSServicesStatus:$KEY:enabled_menu integer 1" "$PLIST" >/dev/null 2>&1
"$PB" -c "Add :NSServicesStatus:$KEY:enabled_context_menu integer 1" "$PLIST" >/dev/null 2>&1
"$PB" -c "Add :NSServicesStatus:$KEY:key_equivalent string ^~@r" "$PLIST" >/dev/null 2>&1
killall cfprefsd 2>/dev/null
/System/Library/CoreServices/pbs -flush 2>/dev/null

echo ""
echo "✅ 安装完成！"
echo ""
echo "【怎么用】"
echo "  1. 在访达里选中 .nev 素材文件"
echo "  2. 右键 → 服务 → NEV转R3D"
echo "     或直接按快捷键 ⌃⌥⌘R"
echo ""
echo "【两个小提示】"
echo "  · 如果转换完成不弹通知：系统设置 → 通知 →"
echo "    找到「Script Editor」→ 打开「允许通知」"
echo "  · 如果右键菜单里暂时看不到服务，注销重登一次即可"
echo ""
read -r -p "按回车键关闭窗口..."
