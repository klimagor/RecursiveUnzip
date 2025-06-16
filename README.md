# Recursive ZIP Extractor

A PowerShell-based tool for extracting nested ZIP files recursively on Windows, with proper support for Hebrew/UTF-8 filenames using 7-zip.

## Features

- **Recursive extraction**: Automatically extracts nested ZIP files at any depth
- **UTF-8/Hebrew support**: Uses 7-zip to properly handle international filenames
- **Right-click integration**: Adds "Extract All Recursively" option to ZIP file context menu
- **Automatic cleanup**: Removes nested ZIP files after successful extraction

## Prerequisites

- **7-zip** installed on your system
  - Download from: https://www.7-zip.org/ and install
  - The script automatically detects 7-zip in common installation locations

## Installation

1. **Install 7-zip** if not already installed
2. **Download/clone all files** to a folder of your choice
3. **Installation of Right-click Context Menu (Recommended)**  
   Right-click `add-context-menu.bat` -> choose `Run as administrator`

## Usage

### Using Right-click Context Menu

1. **Right-click** on any ZIP file in Windows Explorer
2. **Select** "Extract All Recursively" from the context menu
3. The script will:
   - Create a new folder with the ZIP filename + "_extracted"
   - Extract all nested ZIP files recursively
   - Remove all nested ZIP files after successful extraction
   - Display progress messages

### Using Command Line

```powershell
powershell.exe -ExecutionPolicy Bypass -File "recursive-unzip.ps1" "C:\Downloads\nested-archive.zip"

# The extracted contents will be in:
# C:\Downloads\nested-archive.zip_extracted\
```

## Removal

1. **Remove Right-click Context Menu (if was installed)**  
   Double-click `remove-context-menu.reg`
2. **Delete the files**

## How It Works

1. **Initial Extraction**: Extracts the main ZIP file to a new directory
2. **Recursive Processing**: Scans for any ZIP files in the extracted content
3. **Nested Extraction**: Extracts each found ZIP file to a subdirectory
4. **Cleanup**: Removes the ZIP file after successful extraction
5. **Repeat**: Continues until no more ZIP files are found
