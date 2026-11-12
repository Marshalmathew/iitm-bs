# Quick compilation script for Machine Learning Foundations textbook
$ErrorActionPreference = "Stop"

$env:PATH = ($env:PATH -split ';' | Where-Object { 
    $_ -and 
    $_ -notmatch '\.jar$' -and 
    $_ -notlike '*ojdbc*' -and 
    (Test-Path $_ -PathType Container -ErrorAction SilentlyContinue) 
}) -join ';'

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "Compiling Machine Learning Foundations Textbook..." -ForegroundColor Cyan

# Clean previous output
Remove-Item "main.pdf" -ErrorAction SilentlyContinue

# Pass 1
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in first pdflatex pass! Check main.log." -ForegroundColor Red
    exit 1
}

# Index
if (Test-Path "main.idx") {
    & makeindex main.idx
}

# Pass 2
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error in second pdflatex pass! Check main.log." -ForegroundColor Red
    exit 1
}

# Cleanup aux files
$auxFiles = @("*.aux", "*.log", "*.toc", "*.out", "*.synctex.gz", "*.fls", "*.fdb_latexmk", "*.idx", "*.ind", "*.ilg")
foreach ($pattern in $auxFiles) {
    Get-ChildItem -Path . -Filter $pattern -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
}

if (Test-Path "main.pdf") {
    $size = (Get-Item "main.pdf").Length / 1KB
    Write-Host ("Compilation successful! 'main.pdf' generated ({0:N1} KB)." -f $size) -ForegroundColor Green
} else {
    Write-Host "Build finished but 'main.pdf' was not found." -ForegroundColor Yellow
}

