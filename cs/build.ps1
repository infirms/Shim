#Requires -Version 7

<#
.SYNOPSIS
    Build shim.exe using dotnet publish.
.PARAMETER Target
    Target architecture: x86, x64, arm64. Default: all.
.PARAMETER Configuration
    Build configuration: Debug, Release. Default: Release.
#>
param(
  [ValidateSet('x86', 'x64', 'arm64')]
  [string] $Target,
  [ValidateSet('Debug', 'Release')]
  [string] $Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

$ridMap = @{ 'x86' = 'win-x86'; 'x64' = 'win-x64'; 'arm64' = 'win-arm64' }

function Invoke-Build {
  param([string]$Target)

  $rid = $ridMap[$Target]
  $ver = (Get-Content (Join-Path $PSScriptRoot 'version')).Trim()
  Write-Host "Publishing shim for $Target ($rid, $Configuration, version $ver)..." -ForegroundColor Cyan
  & dotnet publish (Join-Path $PSScriptRoot 'shim.csproj') -c $Configuration -r $rid --self-contained false "-p:PublishDir=bin\$Target" "-p:Version=$ver" "-p:FileVersion=$ver" "-p:ProductVersion=$ver" --nologo
  if ($LASTEXITCODE -ne 0) { throw "dotnet publish failed" }
  $exe = Join-Path $PSScriptRoot "bin\$Target\shim.exe"
  if (-not (Test-Path $exe)) { throw "Output not found: $exe" }
}

# Clean bin, build
$binDir = Join-Path $PSScriptRoot 'bin'
Remove-Item -Path $binDir -Recurse -Force -ErrorAction SilentlyContinue

if ($Target) { Invoke-Build $Target }
else { foreach ($t in @('x86', 'x64', 'arm64')) { Invoke-Build $t } }

Write-Host "Done: $binDir" -ForegroundColor Green