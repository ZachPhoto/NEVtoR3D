# nev2r3d.ps1 — 批量把指定目录下的 .nev 素材改名为 .R3D（Windows 版）
# 用法：
#   .\nev2r3d.ps1              # 处理当前目录
#   .\nev2r3d.ps1 -Path "D:\footage"
# 注意：只改扩展名，不做转码；同名 .R3D 已存在时自动跳过。
param(
    [string]$Path = "."
)

$files = Get-ChildItem -Path $Path -File | Where-Object { $_.Extension -ieq ".nev" }

if (-not $files) {
    Write-Host "未在 $Path 找到 .nev 素材文件。"
    exit 0
}

$converted = 0
$skipped = 0

foreach ($f in $files) {
    $target = Join-Path $f.DirectoryName ($f.BaseName + ".R3D")
    if (Test-Path $target) {
        Write-Host "跳过（同名已存在）: $target"
        $skipped++
    } else {
        Rename-Item -LiteralPath $f.FullName -NewName ($f.BaseName + ".R3D")
        Write-Host "OK: $($f.Name) -> $($f.BaseName).R3D"
        $converted++
    }
}

Write-Host ""
Write-Host "完成：转换 $converted 个，跳过 $skipped 个。"
