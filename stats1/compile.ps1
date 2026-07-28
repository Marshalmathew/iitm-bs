# PowerShell script to compile the Stats 1 LaTeX textbook locally

$PdfLatexExists = Get-Command pdflatex -ErrorAction SilentlyContinue

if (-not $PdfLatexExists) {
    Write-Host "=================================================================" -ForegroundColor Yellow
    Write-Host "pdflatex not found. Install MiKTeX (https://miktex.org/) or TeX Live." -ForegroundColor Red
    Write-Host ""
    Write-Host "Recommended alternative: Run .\zip_project.ps1 and upload the zip to Overleaf." -ForegroundColor Green
    Write-Host "=================================================================" -ForegroundColor Yellow
    return
}

Write-Host "Compiling Statistics for Data Science 1 Textbook..." -ForegroundColor Cyan

pdflatex -interaction=nonstopmode main.tex
if (Test-Path "main.idx") { makeindex main.idx }
pdflatex -interaction=nonstopmode main.tex


if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
    Write-Host "Compilation successful! 'main.pdf' generated." -ForegroundColor Green
    $AuxExtensions = @("*.aux","*.log","*.toc","*.out","*.synctex.gz","*.fls","*.fdb_latexmk")
    foreach ($ext in $AuxExtensions) { Remove-Item $ext -ErrorAction SilentlyContinue }
} else {
    Write-Host "Compilation failed. Check pdflatex output above." -ForegroundColor Red
}
