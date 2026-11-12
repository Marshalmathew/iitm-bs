# PowerShell script to compile Programming in Python LaTeX textbook locally

$PdfLatexExists = Get-Command pdflatex -ErrorAction SilentlyContinue

if (-not $PdfLatexExists) {
    Write-Host "=================================================================" -ForegroundColor Yellow
    Write-Host "pdflatex not found. Install MiKTeX (https://miktex.org/) or TeX Live." -ForegroundColor Red
    Write-Host "=================================================================" -ForegroundColor Yellow
    return
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Clean PATH to prevent MiKTeX crash on non-directory path entries like ojdbc11.jar
$env:PATH = ($env:PATH -split ';' | Where-Object { $_ -and $_ -notmatch '\.jar$' -and (Test-Path $_ -PathType Container -ErrorAction SilentlyContinue) }) -join ';'

Write-Host "Compiling Programming in Python Textbook..." -ForegroundColor Cyan

pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex
if (Test-Path "main.idx") { makeindex main.idx }
pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex

if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
    Write-Host "Compilation successful! 'main.pdf' generated." -ForegroundColor Green
    $AuxExtensions = @("*.aux","*.log","*.toc","*.out","*.synctex.gz","*.fls","*.fdb_latexmk","*.idx","*.ind","*.ilg")
    foreach ($ext in $AuxExtensions) { Remove-Item $ext -ErrorAction SilentlyContinue }
} else {
    Write-Host "Compilation failed. Check pdflatex output above." -ForegroundColor Red
}
