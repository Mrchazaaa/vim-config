[CmdletBinding()]
param(
    [string]$ConfigDir = (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'nvim')
)

$ErrorActionPreference = 'Stop'

function Assert-Command {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "$Name is required. Install it and ensure it is available on PATH before running this script."
    }
}

Assert-Command nvim
Assert-Command npm

$repoRoot = (Resolve-Path $PSScriptRoot).Path
$vimConfig = Join-Path $repoRoot 'vim\.vimrc'
$nvimConfig = Join-Path $repoRoot 'nvim\init.lua'

foreach ($config in @($vimConfig, $nvimConfig)) {
    if (-not (Test-Path -LiteralPath $config -PathType Leaf)) {
        throw "Expected configuration file was not found: $config"
    }
}

$initPath = Join-Path $ConfigDir 'init.vim'
$luaInitPath = Join-Path $ConfigDir 'init.lua'

if (Test-Path -LiteralPath $luaInitPath -PathType Leaf) {
    throw "Cannot install because $luaInitPath already exists. Move it aside or merge it into this configuration first."
}

$vimRoot = $repoRoot.Replace('\', '/').Replace("'", "''")
$content = @"
let s:vimconfig_root = '$vimRoot'
execute 'source ' . fnameescape(s:vimconfig_root . '/vim/.vimrc')
execute 'lua dofile(' . string(s:vimconfig_root . '/nvim/init.lua') . ')'
"@ + [Environment]::NewLine

if ((Test-Path -LiteralPath $initPath -PathType Leaf) -and
    [IO.File]::ReadAllText($initPath) -eq $content) {
    Write-Output "$initPath is already up to date."
    exit 0
}

$null = New-Item -ItemType Directory -Force -Path $ConfigDir

if (Test-Path -LiteralPath $initPath -PathType Leaf) {
    $backupPath = "$initPath.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Move-Item -LiteralPath $initPath -Destination $backupPath
    Write-Output "Backed up $initPath to $backupPath"
}

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($initPath, $content, $utf8WithoutBom)
Write-Output "Wrote $initPath"
Write-Output "Neovim will load $initPath."
