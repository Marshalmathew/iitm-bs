# Clean PATH of .jar files that crash MiKTeX
$env:PATH = ($env:PATH -split ';' | Where-Object { 
    $_ -and 
    $_ -notmatch '\.jar$' -and 
    $_ -notlike '*ojdbc*' -and 
    (Test-Path $_ -PathType Container -ErrorAction SilentlyContinue) 
}) -join ';'

Push-Location mlf
Write-Host "Starting Pass 1..."
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Host "Pass 1 FAILED" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "Starting Pass 2..."
& pdflatex -interaction=nonstopmode -halt-on-error -disable-installer main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Host "Pass 2 FAILED" -ForegroundColor Red
    Pop-Location
    exit 1
}

Copy-Item main.pdf ..\compiled_pdfs\mlf.pdf -Force
Write-Host "SUCCESS: mlf compiled and copied to compiled_pdfs/mlf.pdf" -ForegroundColor Green
Pop-Location
