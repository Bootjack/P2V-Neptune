# Deploy P2V-7S mod to DCS World via directory junction
# Junctions do NOT require Administrator (unlike symlinks) and work fine
# for same-volume targets, which is our case (both source and target on D:).

$modSource = "$PSScriptRoot\P2V-7S"
$dcsModDir = "D:\Saved Games\DCS.openbeta\Mods\aircraft"
$modTarget = "$dcsModDir\P2V-7S"

if (-not (Test-Path $modSource)) {
    Write-Error "Source mod directory not found: $modSource"
    exit 1
}

if (-not (Test-Path $dcsModDir)) {
    New-Item -ItemType Directory -Path $dcsModDir -Force | Out-Null
    Write-Host "Created DCS mod directory: $dcsModDir"
}

if (Test-Path $modTarget) {
    $item = Get-Item $modTarget -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Host "Junction already exists: $modTarget -> $($item.Target)"
        exit 0
    } else {
        Write-Error "A non-junction directory already exists at $modTarget. Remove it manually first."
        exit 1
    }
}

New-Item -ItemType Junction -Path $modTarget -Target $modSource | Out-Null
Write-Host "Deployed (junction): $modTarget -> $modSource"
Write-Host "Restart DCS to load the mod."
