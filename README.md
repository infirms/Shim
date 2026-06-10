# Shim

![C#](https://img.shields.io/badge/dynamic/regex?url=https://raw.githubusercontent.com/ScoopInstaller/Shim/refs/heads/main/cs/version&search=%5B%5Cd.%5D%2B&logo=dotnet&label=C#) ![C++](https://img.shields.io/badge/dynamic/regex?url=https://raw.githubusercontent.com/ScoopInstaller/Shim/refs/heads/main/cpp/version&search=%5B%5Cd.%5D%2B&logo=cplusplus&label=C++) ![Rust](https://img.shields.io/badge/dynamic/regex?url=https://raw.githubusercontent.com/ScoopInstaller/Shim/refs/heads/main/rust/version&search=%5B%5Cd.%5D%2B&logo=rust&label=Rust)

A small program that launches the executable specified in its paired `<name>.shim` file. A helper for [Scoop](https://scoop.sh), the Windows command-line installer.

## Shim File Format

```text
path = <path to executable>
args = <arguments>
cwd = <working directory>
elevate = true|false|1|0|yes|no
NAME = <environment variable override>
```

### Comments

Lines starting with `#`, `;`, or `//`, as well as blank lines, are ignored.

### Fields

| Field | Description |
|-------|-------------|
| `path` | **(Required)** Path to the target executable |
| `args` | Arguments passed to the target |
| `cwd` (`workdir`) | Working directory for the target process |
| `elevate` (`runas`) | Request UAC elevation. Valid values: `true`, `1`, `yes` |
| Any other name | Environment variable set for the target process |

### Value Quoting

Values may be wrapped in double quotes (e.g. `path = "C:\Program Files\app.exe"`) or left unquoted.

### Variable Expansion

- `%ENV%` — Expands environment variables in `path`, `args`, `cwd`, and environment override values. Unknown variables (e.g. `%NONEXISTENT_VAR%`) are preserved as-is.
- `%~dp0` — Expands to the **directory containing the target executable** with a trailing backslash. Applies to `args` and `cwd` only (not `path`).

### Argument Parsing

User-provided runtime arguments are appended after those defined in `args`.

### Environment Variables

Any line whose key is not `path`, `args`, `cwd`, `workdir`, `elevate`, or `runas` is treated as an environment variable override for the child process. Keys are case-insensitive.

### Exit Codes

The shim waits for the child process to finish and forwards its exit code. If the shim fails internally, it exits with code 1.

## Usage

The `.shim` file must share the same base name as the `shim.exe`.

```pwsh
New-Item -Path test.shim -Value 'path = C:\Windows\System32\calc.exe'
Copy-Item -Path .\cpp\bin\x64\shim.exe -Destination .\test.exe
.\test.exe
```

## Implementations

- **C#** — .NET Framework 4.5 (CLR). Maintained as the legacy lane.
- **C++** — Native executable with no runtime dependencies. Zig build (default).
- **Rust** — Native executable using `windows-sys` raw FFI bindings. Cargo build.

All implementations share the same `.shim` format.

## Binary Size

| Implementation | Build Tool | x86 | x64 | arm64 |
|----------------|-----------|----:|----:|------:|
| C# | dotnet | 16.5 KB | 16.0 KB | 16.0 KB |
| C++ | Zig | 132.0 KB | 159.5 KB | 152.5 KB |
| C++ | MSBuild | 131.0 KB | 157.0 KB | 142.0 KB |
| Rust | Cargo | 106.5 KB | 120.5 KB | 117.0 KB |

## Development

- C# developer guide: [`cs/README.md`](cs/README.md)
- C++ developer guide: [`cpp/README.md`](cpp/README.md)
- Rust developer guide: [`rust/README.md`](rust/README.md)
- Test suite: [`test/run-tests.ps1`](test/run-tests.ps1)
- Tag-based release routing:
  - `cs/v<version>` → C# release lane
  - `cpp/v<version>` → C++ release lane
  - `rust/v<version>` → Rust release lane

All `build.ps1` scripts accept `-Target x86|x64|arm64` and `-Configuration Debug|Release` (default Release). Output is written to `bin/{Target}/shim.exe`.

## Special Thanks

This repository builds upon the work of several independent projects that pioneered faster, more reliable Scoop shims:

- **[71/scoop-better-shimexe](https://github.com/71/scoop-better-shimexe)** — The groundbreaking C implementation that solved Ctrl+C passthrough and eliminated .NET startup overhead.

- **[kiennq/scoop-better-shimexe](https://github.com/kiennq/scoop-better-shimexe)** — C++ fork of 71's work, adding MSBuild support and the `cwd` field to the shim format.

- **[zoritle/rshim](https://github.com/zoritle/rshim)** — Rust implementation focused on memory safety and proper UTF-8 BOM handling.

- **[svercl/zshim](https://github.com/svercl/zshim)** — Pure Zig port that proved a shim can be built with zero runtime dependencies.

## License

This project is dual-licensed under the [Unlicense](UNLICENSE) or the [MIT License](LICENSE).

You may choose either license.
