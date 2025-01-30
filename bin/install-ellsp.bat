@echo off

:: Copyright (C) 2023-2025 the Ellsp authors.

:: This program is free software; you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation; either version 3, or (at your option)
:: any later version.

:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.

:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <https://www.gnu.org/licenses/>.

::: Commentary:
::
:: TODO(everyone): Keep this script simple and easily auditable.
::

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
    set ARCH=x64
) else if "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
    set ARCH=arm64
) else (
    echo Error: Unsupported architecture detected: `%PROCESSOR_ARCHITECTURE%`.
    exit /b 1
)

set URL=https://github.com/elisp-lsp/ellsp/releases/latest/download/ellsp_win-%ARCH%.zip
set ELLSP_BIN_DIR=%~dp0
set ZIP=%ELLSP_BIN_DIR%\ellsp.zip

curl.exe -fsSL %URL% -o %ZIP%

tar.exe -xf %ZIP% -C %ELLSP_BIN_DIR%

del %ZIP%

echo.
echo ✓ Ellsp is installed in %ELLSP_BIN_DIR%.
echo.
