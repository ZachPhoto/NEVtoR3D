#!/bin/bash
# NEVtoR3D 双击安装器 —— 下载解压后双击本文件即可，无需打开终端
# 安装逻辑统一在 install.sh，本文件只负责双击包装（欢迎语 + 调脚本 + 暂停看结果）
cd "$(dirname "$0")" || exit 1
clear

echo "======================================"
echo "   NEVtoR3D 一键安装"
echo "   尼康 N-RAW (.nev) → .R3D 右键服务"
echo "======================================"
echo ""

if [ ! -d "NEVtoR3D.workflow" ] || [ ! -f "install.sh" ]; then
  echo "❌ 缺少 NEVtoR3D.workflow 或 install.sh"
  echo ""
  echo "请确认完整安装包的所有文件都在同一个文件夹里，"
  echo "不要单独把安装器拖出来运行。"
  echo ""
  read -r -p "按回车键关闭窗口..."
  exit 1
fi

./install.sh

echo ""
read -r -p "按回车键关闭窗口..."
