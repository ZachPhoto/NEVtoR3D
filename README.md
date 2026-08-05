# NEVtoR3D

**macOS 一键把尼康 N-RAW 素材 `.nev` 批量改名为 `.R3D` 的右键快捷服务**——用更省空间的 N-RAW 拍摄，又能让 DaVinci Resolve 以 RED 色彩科学处理素材。

## 为什么要改名？

1. **N-RAW 更省空间**：相比机内直接录 R3D，用 N-RAW 正常档位拍摄体积更小、更省存储
2. **获得近似 RED 的色彩科学**：改名 `.R3D` 后，DaVinci Resolve 会按 RED 的色彩管线来解码素材——不支持机内 R3D 的尼康机型（如 Z8 / Z9），也能借此获得近似 RED 的色彩表现

> ⚠️ **重要说明**：本工具只修改文件扩展名，**不做任何转码**。改名是社区广泛使用的技巧，利用后期软件按扩展名选择解码管线的机制工作。请先在测试素材上验证你的工作流可用，再批量处理；改名后尼康自家软件（如 NX Studio）可能不再识别这些文件。

## 特性

- 🖱️ **右键即用**：选中素材 → 右键 → 服务 → NEV转R3D
- ⌨️ **键盘快捷键**：默认 `⌃⌥⌘R`，选中文件一按即转（安装时可选设置）
- 🔤 **大小写不敏感**：`.NEV` / `.nev` / `.Nev` 全部支持
- 🛡️ **安全保护**：同名 `.R3D` 已存在时自动跳过，绝不覆盖
- 🎬 **代理文件识别**：相机生成的 `.nev.mov` 代理文件会被自动识别并忽略，并给出明确提示
- 🔔 **完成反馈**：系统通知 + 提示音，转换/跳过/失败数量一目了然
- 📋 **运行日志**：每次操作记录到 `~/Library/Logs/NEVtoR3D.log`，排障有据可查

## 安装

**方式一：双击安装包（推荐，无需任何命令行）**

1. 到 [Releases](../../releases) 下载最新的 `NEVtoR3D-安装包-vX.X.zip` 并解压
2. **双击「双击安装.command」**——自动完成安装、注册和快捷键设置
3. 如果系统提示"无法打开，因为来自身份不明的开发者"：**右键点它 → 打开** 即可

**方式二：命令行一键脚本**

```bash
git clone https://github.com/ZachPhoto/NEVtoR3D.git
cd NEVtoR3D
./install.sh        # 或双击 install.command，效果相同
```

**方式三：手动安装**

1. 下载本仓库（Code → Download ZIP 并解压）
2. 双击 `NEVtoR3D.workflow`，在系统弹窗中点「安装」
3. 或直接把 `NEVtoR3D.workflow` 拷贝到 `~/Library/Services/`

**卸载**

```bash
./uninstall.sh
```

## 使用

1. 在访达中选中一个或多个 `.nev` 素材文件
2. 右键 → **服务** → **NEV转R3D**，或按快捷键 `⌃⌥⌘R`
3. 屏幕右上角弹出通知：「已转换 N 个文件为 .R3D」

> 提示：若通知不弹，请在 **系统设置 → 通知** 中允许「Script Editor」通知。

## 常见问题

**Q：点了服务「没反应」？**

先看日志，一行命令定位：

```bash
tail -20 ~/Library/Logs/NEVtoR3D.log
```

- 没有新记录 → 服务没被触发，确认先选中了文件
- 「忽略(非NEV)」→ 文件后缀不是 `.nev`。注意访达默认隐藏扩展名：显示为「DSC_0205.nev」的文件，真实全名可能是 `DSC_0205.nev.mov`（见下条）
- 「OK」但没弹通知 → 去 系统设置 → 通知 允许「Script Editor」通知，并检查专注模式

**Q：`.nev.mov` 是什么文件？**

这是相机为 N-RAW 主文件生成的 **H.265 代理文件**，不是 RAW 素材，无需也不能转为 R3D。工具会自动识别并跳过，请处理同名的 `.nev` 主文件。

**Q：右键菜单里找不到服务？**

```bash
/System/Library/CoreServices/pbs -flush && killall Finder
```

或双击 `NEVtoR3D.workflow` 用 Automator 打开后 `⌘S` 保存，强制重新注册。

**Q：想改快捷键？**

系统设置 → 键盘 → 键盘快捷键 → 服务 → NEV转R3D。

## Windows 用户

`windows/nev2r3d.ps1` 提供等价功能：

```powershell
# 转换当前目录（默认）或指定目录下所有 .nev 文件
.\nev2r3d.ps1 -Path "D:\footage"
```

也可以使用微软官方免费的 **PowerToys → PowerRename** 图形界面批量改名。

## 免责声明

- 本项目为**非官方社区工具**，与 Nikon、RED 无任何关联，相关商标归其所有者。
- 改名操作**不修改文件内容**，但可能影响相机厂商软件的识别。请自行备份素材，在测试验证后再批量使用，风险自负。

## 贡献

欢迎 Issue 和 PR。如在你自己的机型/系统版本上验证可用，也欢迎在 Issue 中反馈，帮助完善兼容列表。

## License

[MIT](LICENSE)

---

## English Summary

**NEVtoR3D** is a macOS Finder Quick Action that batch-renames Nikon N-RAW `.nev` files to `.R3D` (case-insensitive). Why rename? N-RAW at normal quality is smaller than recording R3D in-camera, and renaming to `.R3D` lets DaVinci Resolve decode the footage through RED's color pipeline — giving Nikon bodies without in-camera R3D (e.g. Z8 / Z9) a RED-like color science. Right-click → Services → NEVtoR3D, or press `⌃⌥⌘R`. It never overwrites existing files, automatically skips camera `.nev.mov` proxy files, and logs every run to `~/Library/Logs/NEVtoR3D.log`.

> **Note**: This tool renames extensions only — it does NOT transcode. It is an unofficial community project, not affiliated with Nikon or RED. Test on a few files before batch use.

Install: `./install.sh` · Uninstall: `./uninstall.sh` · Windows: `windows/nev2r3d.ps1`
