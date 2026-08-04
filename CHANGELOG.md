# Changelog

## [1.0.0] - 2026-08-04

首个公开发布版本 🎉

- macOS 访达右键服务：选中 `.nev` 素材一键批量改名为 `.R3D`（大小写不敏感）
- 默认快捷键 `⌃⌥⌘R`，可在系统设置中自定义
- 自动识别并跳过相机 `.nev.mov` 代理文件，给出专属提示
- 同名 `.R3D` 已存在时自动跳过，绝不覆盖
- 系统通知 + 提示音反馈，运行日志记录到 `~/Library/Logs/NEVtoR3D.log`
- 双击安装器（install.command）：解压双击即可安装，无需命令行
- install.sh / uninstall.sh 命令行安装卸载脚本
- Windows 等价方案：PowerShell 脚本
- MIT License
