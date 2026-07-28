# PowerShell script to package the LaTeX textbook for Overleaf upload

$SourceFiles = @(
    "main.tex"
    "preamble.tex"
    "appendix.tex"
    "chapters"
)

$ZipName = "stats1_textbook.zip"
$ZipPath = ".\$ZipName"

Write-Host "Packaging Statistics 1 LaTeX textbook for Overleaf upload..." -ForegroundColor Cyan

foreach ($file in $SourceFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Source file or folder '$file' not found."
        return
    }
}

if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }

Compress-Archive -Path $SourceFiles -DestinationPath $ZipPath -Force

if (Test-Path $ZipPath) {
    Write-Host "Success! Created: $ZipName" -ForegroundColor Green
    Write-Host "Upload this zip file directly to Overleaf (https://www.overleaf.com/)." -ForegroundColor Yellow
} else {
    Write-Host "Failed to create zip file." -ForegroundColor Red
}
