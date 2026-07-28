#!/usr/bin/env bash
# Bash script to compile all IITM BS course textbooks locally on Linux/macOS

set -e

COURSES=("maths1" "maths2" "python" "stats1" "stats2")

if ! command -v pdflatex &> /dev/null; then
    echo -e "\033[33m=================================================================\033[0m"
    echo -e "\033[31mpdflatex not found in system PATH.\033[0m"
    echo -e "\033[33mInstall TeX Live or MacTeX to compile locally.\033[0m"
    echo -e "\033[33m=================================================================\033[0m"
    exit 1
fi

echo -e "\033[36m=================================================================\033[0m"
echo -e "\033[36mIITM BS Textbooks: Batch Compilation Started\033[0m"
echo -e "\033[36m=================================================================\033[0m"

SUCCESS_COUNT=0
FAIL_COUNT=0

for course in "${COURSES[@]}"; do
    if [ ! -d "$course" ]; then
        echo -e "\033[33mDirectory '$course' not found. Skipping.\033[0m"
        continue
    fi

    echo -e "\n\033[33mCompiling textbook for course: [$course]...\033[0m"
    cd "$course"

    rm -f main.pdf

    pdflatex -interaction=nonstopmode main.tex > /dev/null 2>&1 || true

    if [ -f "main.idx" ]; then
        echo -e "\033[90mGenerating index for [$course]...\033[0m"
        makeindex main.idx > /dev/null 2>&1 || true
    fi

    if pdflatex -halt-on-error -interaction=nonstopmode main.tex > /dev/null 2>&1; then
        if [ -f "main.pdf" ]; then
            SIZE=$(du -k "main.pdf" | cut -f1)
            echo -e "\033[32mSUCCESS: [$course] -> main.pdf (${SIZE} KB)\033[0m"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            
            # Cleanup aux files
            rm -f *.aux *.log *.toc *.out *.synctex.gz *.fls *.fdb_latexmk *.idx *.ind *.ilg
        else
            echo -e "\033[31mFAILED: [$course] failed to produce main.pdf.\033[0m"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "\033[31mFAILED: [$course] failed to compile. See $course/main.log for details.\033[0m"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi

    cd ..
done

echo -e "\n\033[36m=================================================================\033[0m"
echo -e "\033[36mCompilation Summary: $SUCCESS_COUNT Passed, $FAIL_COUNT Failed\033[0m"
echo -e "\033[36m=================================================================\033[0m"

if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
fi
