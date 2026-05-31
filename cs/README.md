# C# shim (legacy)

This directory contains the legacy C# implementation worktree for Scoop `shim.exe`.

For product-level behavior and packaged README content, see [`..\README.md`](..\README.md).

## Layout

- `shim.sln` - solution entry
- `src/` - shim executable project
- `test/` - xUnit test project
- `release-build.ps1` - local release packaging script

## Prerequisites

- .NET SDK 8 or newer for test project tooling
- .NET Framework targeting pack for `net45` build
- PowerShell 7 for `release-build.ps1`

## Development

### From monorepo root

```powershell
dotnet build .\csharp\shim.sln
dotnet test .\csharp\test\test.csproj
pwsh .\csharp\release-build.ps1
```

### From `csharp\`

```powershell
dotnet build .\shim.sln
dotnet test .\test\test.csproj
pwsh .\release-build.ps1
```

## Outputs

- debug build: `src\bin\Debug\net45\shim.exe`
- release build: `src\bin\Release\net45\shim.exe`
- packaged artifacts: `dist\`

## Notes

- repository metadata now lives at monorepo root
- workflow files run from monorepo root but target this directory explicitly
- package metadata reads both license and packaged README from monorepo root
