#!/usr/bin/env python3
# make-release.py —— 生成发布安装包 zip
# 用法: python3 make-release.py [版本号]   # 默认 v1.0.0
# 输出: NEVtoR3D-安装包-<版本号>.zip
# 为什么不用 zip 命令：macOS 自带 zip 对中文文件名的编码兼容性差，
# Windows 解压会乱码；zipfile 默认 UTF-8 + flag bit 11，两端都正常。
import os
import shutil
import sys
import tempfile
import zipfile

ROOT = os.path.dirname(os.path.abspath(__file__))
VERSION = sys.argv[1] if len(sys.argv) > 1 else "v1.0.0"
OUT = os.path.join(ROOT, f"NEVtoR3D-安装包-{VERSION}.zip")

stage = tempfile.mkdtemp(prefix="nev2r3d-")
pkg = os.path.join(stage, "NEVtoR3D 安装包")
os.makedirs(pkg)

# 打包内容：workflow + 双击安装器 + install.sh（双击安装器依赖它）+ 使用说明
shutil.copytree(
    os.path.join(ROOT, "NEVtoR3D.workflow"),
    os.path.join(pkg, "NEVtoR3D.workflow"),
    ignore=shutil.ignore_patterns(".DS_Store"),
)
shutil.copy(os.path.join(ROOT, "install.command"), os.path.join(pkg, "双击安装.command"))
shutil.copy(os.path.join(ROOT, "install.sh"), os.path.join(pkg, "install.sh"))
shutil.copy(os.path.join(ROOT, "使用说明.txt"), os.path.join(pkg, "使用说明.txt"))

with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zf:
    for dirpath, _dirs, files in os.walk(pkg):
        for fn in files:
            full = os.path.join(dirpath, fn)
            zf.write(full, os.path.relpath(full, stage))

shutil.rmtree(stage, ignore_errors=True)
print(f"✅ 已生成 {OUT}")
