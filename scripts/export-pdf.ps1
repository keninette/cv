# Exports the CV to PDF using headless Edge (or Chrome):
#   src/index.html   -> build/CV-GAUTHIER-HUGENDOBLER-Delphine.pdf      (graphic CV)
#   src/ats/ats.html -> build/CV-GAUTHIER-HUGENDOBLER-Delphine-ATS.pdf  (ATS CV, rendered from src/ats/ats.md)
# It does the same as opening each page and using "Print > Save as PDF", without opening a window.
# Page size (A4), margins and background colours come from the pages' CSS (@page and print-color-adjust).
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

# Page to print (relative to src) -> output PDF (relative to build).
$exports = @{
  "index.html"   = "CV-GAUTHIER-HUGENDOBLER-Delphine.pdf"
  "ats\ats.html" = "CV-GAUTHIER-HUGENDOBLER-Delphine-ATS.pdf"
}

foreach ($page in $exports.Keys) {
  # Input page as a file:/// URL (backslashes turned into slashes), and output PDF path.
  $src = "file:///" + ((Join-Path $root "src\$page") -replace '\\', '/')
  $out = Join-Path $root "build\$($exports[$page])"

  # Run the browser without a window and print the page to the PDF:
  #   --headless=new            no visible window
  #   --disable-gpu             avoids GPU issues in headless mode
  #   --no-pdf-header-footer    no date / title / URL printed in the margins
  #   --allow-file-access-from-files  lets the pages load their files from disk (components, ats.md)
  #   --print-to-pdf            where to write the PDF
  # The browser prints once the page has loaded (fonts, icons, includes and the preloaded
  # background images in index.html). Don't add --virtual-time-budget: it makes the PDF
  # print hang forever with the nested includes.
  # Browser log noise (stderr) is discarded.
  & $browser --headless=new --disable-gpu --no-pdf-header-footer --allow-file-access-from-files `
    --print-to-pdf="$out" $src 2>$null | Out-Null
  Write-Host "PDF written to $out"
}
