# PowerShell script to compile all IITM BS course textbooks locally

$Courses = @("maths1", "maths2", "python", "stats1", "stats2")
$PdfLatexExists = Get-Command pdflatex -ErrorAction SilentlyContinue

if (-not $PdfLatexExists) {
    Write-Host "=================================================================" -ForegroundColor Yellow
    Write-Host "pdflatex not found in system PATH." -ForegroundColor Red
    Write-Host "Install MiKTeX (https://miktex.org/) or TeX Live to compile locally." -ForegroundColor Yellow
    Write-Host "=================================================================" -ForegroundColor Yellow
    exit 1
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "IITM BS Textbooks: Batch Compilation Started" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

$SuccessCount = 0
$FailCount = 0
$Results = @()

foreach ($course in $Courses) {
    $CoursePath = ".\$course"
    if (-not (Test-Path $CoursePath)) {

        Write-Host "Directory '$course' not found. Skipping." -ForegroundColor Yellow
        continue
    }

    Write-Host "`nCompiling textbook for course: [$course]..." -ForegroundColor Yellow
    Push-Location $CoursePath

    # Clean previous output
    Remove-Item "main.pdf" -ErrorAction SilentlyContinue

    # First pdflatex pass
    & pdflatex -interaction=nonstopmode main.tex | Out-Null

    # Run makeindex if idx file was generated
    if (Test-Path "main.idx") {
        Write-Host "Generating index for [$course]..." -ForegroundColor Gray
        & makeindex main.idx | Out-Null
    }

    # Second pdflatex pass
    & pdflatex -interaction=nonstopmode main.tex | Out-Null

    if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
        $PdfSize = (Get-Item "main.pdf").Length / 1KB
        Write-Host "SUCCESS: [$course] -> main.pdf ({0:N1} KB)" -f $PdfSize -ForegroundColor Green
        $SuccessCount++
        $Results += [PSCustomObject]@{ Course = $course; Status = "PASS"; SizeKB = [math]::Round($PdfSize, 1) }

        # Cleanup auxiliary build files
        $AuxExtensions = @("*.aux", "*.log", "*.toc", "*.out", "*.synctex.gz", "*.fls", "*.fdb_latexmk", "*.idx", "*.ind", "*.ilg")
        foreach ($ext in $AuxExtensions) {
            Get-ChildItem -Recurse -Include $ext | Remove-Item -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "FAILED: [$course] failed to compile. See $course/main.log for details." -ForegroundColor Red
        $FailCount++
        $Results += [PSCustomObject]@{ Course = $course; Status = "FAIL"; SizeKB = 0 }
    }

    Pop-Location
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "Compilation Summary: $SuccessCount Passed, $FailCount Failed" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
$Results | Format-Table -AutoSize

if ($FailCount -gt 0) {
    exit 1
}
