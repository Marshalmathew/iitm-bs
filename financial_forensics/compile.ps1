# PowerShell script to compile Financial Forensics Textbook locally
$env:PATH = ($env:PATH -split ';' | Where-Object { 
    $_ -and 
    $_ -notmatch '\.jar$' -and 
    $_ -notlike '*ojdbc*' -and 
    (Test-Path $_ -PathType Container -ErrorAction SilentlyContinue) 
}) -join ';'

$PdfLatexExists = Get-Command pdflatex -ErrorAction SilentlyContinue

if (-not $PdfLatexExists) {
    Write-Host "pdflatex not found in PATH." -ForegroundColor Red
    exit 1
}

Write-Host "Compiling Financial Forensics Textbook..." -ForegroundColor Cyan
Push-Location $PSScriptRoot

Remove-Item "main.pdf" -ErrorAction SilentlyContinue

# First pass
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex

if (Test-Path "main.idx") {
    Write-Host "Generating index..." -ForegroundColor Gray
    & makeindex main.idx
}

# Second pass
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex

if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
    $PdfSize = (Get-Item "main.pdf").Length / 1KB
    $Msg = "Compilation successful! 'main.pdf' generated ({0:N1} KB)." -f $PdfSize
    Write-Host $Msg -ForegroundColor Green
} else {
    Write-Host "Compilation failed. Check pdflatex output above." -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location

