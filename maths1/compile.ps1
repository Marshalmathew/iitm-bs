# PowerShell script to compile the LaTeX textbook locally

$PdfLatexExists = Get-Command pdflatex -ErrorAction SilentlyContinue

if (-not $PdfLatexExists) {
    Write-Host "=================================================================" -ForegroundColor Yellow
    Write-Host "pdflatex command was not found in your system's PATH." -ForegroundColor Red
    Write-Host "To compile this textbook locally, you need a LaTeX distribution:" -ForegroundColor Yellow
    Write-Host "  - Windows: MiKTeX (https://miktex.org/) or TeX Live" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Alternative Suggestion (Recommended):" -ForegroundColor Green
    Write-Host "  1. Run the './zip_project.ps1' script to create 'maths1_textbook.zip'." -ForegroundColor Yellow
    Write-Host "  2. Upload the zip file directly to Overleaf (https://www.overleaf.com/)." -ForegroundColor Yellow
    Write-Host "  3. Overleaf will compile the PDF online instantly without any local setup!" -ForegroundColor Yellow
    Write-Host "=================================================================" -ForegroundColor Yellow
    return
}

Write-Host "Compiling Mathematics for Data Science 1 Textbook..." -ForegroundColor Cyan

# Run pdflatex and makeindex to resolve Table of Contents, Index, and references
pdflatex -interaction=nonstopmode main.tex
if (Test-Path "main.idx") { makeindex main.idx }
pdflatex -interaction=nonstopmode main.tex


if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
    Write-Host "Compilation successful! 'main.pdf' has been generated." -ForegroundColor Green
    
    # Optional cleanup of auxiliary files
    Write-Host "Cleaning up auxiliary files..." -ForegroundColor Gray
    $AuxExtensions = @("*.aux", "*.log", "*.toc", "*.out", "*.synctex.gz", "*.fls", "*.fdb_latexmk")
    foreach ($ext in $AuxExtensions) {
        Remove-Item $ext -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Compilation failed. Please inspect pdflatex log output." -ForegroundColor Red
}
