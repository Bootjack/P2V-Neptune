# Remove P2V-7S mod symlink from DCS World
# Must be run as Administrator

$modTarget = "D:\Saved Games\DCS.openbeta\Mods\aircraft\P2V-7S"

if (-not (Test-Path $modTarget)) {
    Write-Host "No mod found at $modTarget. Nothing to remove."
    exit 0
}

$item = Get-Item $modTarget
if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    (Get-Item $modTarget).Delete()
    Write-Host "Removed symlink: $modTarget"
} else {
    Write-Error "$modTarget is not a symlink. Remove it manually if intended."
    exit 1
}
