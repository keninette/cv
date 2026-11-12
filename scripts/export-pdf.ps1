# Exports src/index.html to build/CV-GAUTHIER-Delphine.pdf using headless Edge (or Chrome).
# It does the same as opening the page and using "Print > Save as PDF", without opening a window.
# Page size (A4), margins and background colours come from src/style.css (@page and print-color-adjust).
# Usage:  powershell -ExecutionPolicy Bypass -File .\scripts\export-pdf.ps1

# Project root (the cv folder, parent of this scripts folder), so it works from any current directory.
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Use the first browser found among the usual Windows install paths.
$browser = @(
  "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
  "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
  "C:\Program Files\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Edge or Chrome not found." }

# Input page as a file:/// URL (backslashes turned into slashes), and output PDF path.
$src = "file:///" + ((Join-Path $root "src\index.html") -replace '\\', '/')
$out = Join-Path $root "build\CV-GAUTHIER-Delphine.pdf"

# Run the browser without a window and print the page to the PDF:
#   --headless=new            no visible window
#   --disable-gpu             avoids GPU issues in headless mode
#   --no-pdf-header-footer    no date / title / URL printed in the margins
#   --virtual-time-budget     waits up to 8 s so Google Fonts and icons are loaded before printing
#   --allow-file-access-from-files  lets index.html load the components/*.html files from disk
#   --print-to-pdf            where to write the PDF
# Browser log noise (stderr) is discarded.
& $browser --headless=new --disable-gpu --no-pdf-header-footer --allow-file-access-from-files `
  --virtual-time-budget=8000 --print-to-pdf="$out" $src 2>$null | Out-Null
Write-Host "PDF written to $out"
