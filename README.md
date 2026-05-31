# Shim

A small program that calls the executable configured in a `<name of itself>.shim` file.

This is a helper program for [Scoop](https://scoop.sh), the Windows command-line installer.

# Shim File Format
```
path = <path to executable without quotes>
args = <arguments>
```

# Usage
The `*.shim` file must have the same name as the `shim.exe`.

```pwsh
New-Item -Path test.shim -Value 'path = C:\Windows\System32\calc.exe'
Copy-Item -Path .\build\shim.exe -Destination .\test.exe
.\test.exe
```

## Development

- C# implementation: [`cs/README.md`](cs/README.md)

## License

This project is dual-licensed under the [Unlicense](UNLICENSE) or the [MIT License](LICENSE).

You may choose either license.
