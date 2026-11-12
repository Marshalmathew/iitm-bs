# IITM BS Course Textbook Expansion Template (Mastery Edition)

This document provides the blueprint for expanding any set of revision notes for the IITM BS Degree into a full, rigorous, and interactive-inspired companion textbook. It establishes the architectural standards, LaTeX preamble definitions, conceptual trap frameworks, comparative synthesis structures, and question design guidelines derived from best-in-class pedagogical systems.

---

## 1. Core Pedagogical Philosophy: From Passive Summary to Active Mastery

Standard lecture notes frequently fail students in three predictable ways:
1. **Computational Tunnel Vision:** Students learn how to plug numbers into formulas (e.g., compute a $Z$-statistic or take a derivative) but fail conceptual questions that probe definitions under subtle constraints.
2. **Invisible Traps:** Objective quizzes in the IITM BS degree actively test common statistical and mathematical fallacies (e.g., base-rate fallacies, confusing likelihood with posterior probability, treating confidence intervals as parameter probabilities).
3. **Siloed Concepts:** Concepts are taught in isolation rather than contrasted side-by-side (e.g., MME vs. MLE vs. MAP, or permutation vs. combination).

Every textbook in this repository must incorporate **five foundational pillars**:
- **Rigorous Formulations:** Unambiguous mathematical definitions and proofs.
- **Visual & Geometric Intuition:** PGFPlots/TikZ diagrams illustrating parameter shifts and asymptotic behavior.
- **Exam Traps & Misconceptions (`trapbox`):** Explicit identification and dismantling of cognitive fallacies and examiner traps.
- **Comparative Synthesis Tables:** Side-by-side matrices contrasting related estimators, tests, or algorithms.
- **Dual-Tier Exercises:** Traditional calculation problems paired with **Diagnostic Conceptual MCQs** whose distractors are thoroughly explained in the appendix.

---

## 2. Directory Structure

For any course (e.g., `stats1`, `stats2`, `maths1`, `maths2`, `python`), adhere strictly to this directory structure:

```text
iitm-bs/
├── common_preamble.tex        # Master typography, colors, and box definitions
└── <course_name>/
    ├── main.tex              # Driver file (frontmatter, includes, index, appendix)
    ├── preamble.tex          # Course-specific macros and inputs ../common_preamble.tex
    ├── appendix.tex          # Exhaustive step-by-step solutions for ALL chapter exercises
    └── chapters/
        ├── week01.tex        # Week 1 Content
        ├── week02.tex        # Week 2 Content
        └── ...
```

---

## 3. LaTeX Preamble & Styling Standards

All textbooks share styling through `common_preamble.tex`. Course-specific `preamble.tex` files must simply `\input{../common_preamble.tex}` and define course-specific mathematical operators (e.g., `\E`, `\Var`, `\Bias`, `\Corr`).

### Required Packages
Ensure `common_preamble.tex` includes:
- `tcolorbox` (with `[most]`, `\usetikzlibrary{shadows,shapes,arrows}`)
- `hyperref`, `qrcode`, `imakeidx`, `listings`
- `pgfplots` (`\pgfplotsset{compat=1.18}`), `venndiagram`, `booktabs`, `array`

### Core Semantic Box Environments

```latex
% --- Core Environments ---
% 1. Definition Box (Teal)
\newtcolorbox{definitionbox}[1]{
    colback=tealbg, colframe=tealborder, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Definition: #1}, enhanced, attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=tealdef, colframe=tealborder, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 2. Theorem / Rule Box (Slate Blue)
\newtcolorbox{theorembox}[1]{
    colback=primarylight, colframe=primaryborder, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Theorem/Rule: #1}, enhanced, attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=primarydark, colframe=primaryborder, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 3. Core Intuition Box (Purple)
\newtcolorbox{intuitionbox}[1]{
    colback=purple!5!white, colframe=purple!75!black, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Core Intuition: #1}, enhanced, attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=purple!75!black, colframe=purple!90!black, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 4. Exam Trap & Misconception Box (Crimson / Ruby) -- ESSENTIAL
\definecolor{traprad}{HTML}{991b1b}
\definecolor{trapbg}{HTML}{fef2f2}
\definecolor{trapborder}{HTML}{ef4444}
\newtcolorbox{trapbox}[1]{
    colback=trapbg, colframe=trapborder, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Exam Trap \& Common Misconception: #1}, enhanced,
    attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=traprad, colframe=trapborder, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 5. Key Formula Box (Coral / Amber)
\newtcolorbox{formulabox}[1]{
    colback=coralbg, colframe=coralborder, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Key Formula: #1}, enhanced, attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=coralformula, colframe=coralborder, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 6. Worked Example Box (Violet)
\newtcolorbox{examplebox}[1]{
    colback=purplebg, colframe=purpleborder, coltitle=white, fonttitle=\bfseries\sffamily,
    title={Example: #1}, enhanced, attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=purpleex, colframe=purpleborder, arc=1mm},
    arc=2mm, boxrule=0.8mm, top=4mm, bottom=3mm, left=3mm, right=3mm, drop shadow={opacity=0.1, color=black}
}

% 7. Video Card (Self-Contained QR & Link)
\newtcolorbox{videocard}[2]{
    colback=ytcardbg, colframe=ytcardborder, enhanced, boxrule=0.5mm, arc=1.5mm,
    left=3mm, right=3mm, top=3mm, bottom=3mm, fontupper=\small\sffamily,
    title={\href{#2}{\textcolor{yttext}{\textbf{Video Resource:}} \textcolor{primarydark}{#1}} \hfill \raisebox{-1.5mm}{\qrcode[height=0.6cm]{#2}}},
    coltitle=primarydark, colbacktitle=ytcardbg,
    attach boxed title to top left={yshift=-2mm, xshift=2mm},
    boxed title style={colback=ytcardbg, colframe=ytcardbg}
}
```

---

## 4. Standard Chapter Architecture (`weekXX.tex`)

Every weekly chapter must strictly follow this 9-part pedagogical anatomy:

### 1. Chapter Title & Learning Objectives
Begin with an executive summary box laying out the exact 3–5 competencies the student will master.

### 2. Theoretical Foundations
Present mathematical concepts systematically using `definitionbox` and `theorembox`. Maintain indexing tags (`\index{...}`) on all formal terms.

### 3. Geometric & Asymptotic Intuition
Include an `intuitionbox` and, where applicable, PGFPlots/TikZ diagrams illustrating curve shifts (e.g., how variance $\sigma^2/n$ collapses as $n$ grows, or how loss surfaces behave).

### 4. Exam Traps & Cognitive Gotchas (`\begin{trapbox}`)
Dedicate space to address classic misunderstandings. Specifically target:
- Boundary conditions (e.g., non-regular models where derivatives fail).
- Inversion errors (e.g., $P(A \mid B) \neq P(B \mid A)$, or interpreting $p$-values as $P(H_0 \mid \text{data})$).
- Non-invariance fallacies (e.g., expectation of a function vs. function of expectation: $\E[g(X)] \neq g(\E[X])$).

### 5. Comparative Synthesis Matrix
For multi-concept chapters, insert a clean `\begin{table}` or `tabular` summarizing trade-offs, assumptions, properties, and computational demands across competing techniques.

### 6. Applied Data Science Code Snippets
Include Python/NumPy/SciPy implementations. Do not stop at trivial API calls; demonstrate:
- Numerical stability issues (e.g., log-sum-exp, avoiding floating point underflow).
- Monte Carlo simulations that verify theoretical properties (e.g., verifying that $p$-values are distributed uniformly under the null).

### 7. Primary Video Lecture References
Embed `\begin{videocard}` references to official NPTEL/IITM lectures so students can pair reading with official instruction.

### 8. Practice Exercises (Two-Tier Structure)
Each chapter must conclude with 5–7 problems split into:
- **Tier 1: Computational & Analytical Derivations:** Step-by-step mathematical calculation.
- **Tier 2: Diagnostic Concept Traps (MCQs):** Multiple-choice questions specifically designed around intuitive distractor options.

### 9. Appendix Routing & Solutions
Every single exercise must have a fully written, rigorous solution in `appendix.tex`. For diagnostic questions, the solution must explicitly state why the false options are tempting yet wrong.

---

## 5. Blueprint for Chapter Practice Exercises & Appendix

### In `weekXX.tex`:
```latex
\newpage
\section{Practice Exercises}
\textit{Detailed step-by-step solutions are available in the Appendix.}

\subsection*{Part A: Analytical \& Computational Problems}
\begin{enumerate}
    \item \textbf{Analytical Problem Name:} Problem statement...
    \item \textbf{Data Science Scenario:} Practical scenario statement...
\end{enumerate}

\subsection*{Part B: Conceptual Diagnostic Traps (Exam Gotchas)}
\begin{enumerate}[resume]
    \item \textbf{Diagnostic Trap:} A researcher performs...
    Which of the following statements is strictly correct?
    \begin{enumerate}
        \item Common fallacy A.
        \item Common fallacy B.
        \item The mathematically sound statement C.
        \item Common fallacy D.
    \end{enumerate}
\end{enumerate}
```

### In `appendix.tex`:
```latex
\section*{Week XX: Topic Name}
\subsection*{Detailed Solutions}

\textbf{1. Analytical Problem Name}
Detailed step-by-step mathematical proof or calculation...

\textbf{3. Diagnostic Trap (Exam Gotcha)}
\begin{itemize}
    \item \textbf{Correct Answer: (c)}
    \item \textbf{Why (c) is correct:} Mathematical explanation...
    \item \textbf{Why (a), (b), and (d) are false:}
        \begin{itemize}
            \item \textbf{(a) Fallacy:} Explaining the base-rate/p-value/support fallacy.
            \item \textbf{(b) Fallacy:} Explaining the sample size confusion.
            \item \textbf{(d) Fallacy:} Explaining the variance/bias trade-off trap.
        \end{itemize}
\end{itemize}
```

---

## 6. Systematic Textbook Rollout Plan

To upgrade all course textbooks across the IITM BS repository systematically, execute in this order:

| Phase | Target | Scope & Actions |
| :---: | :--- | :--- |
| **Phase 1** | **`common_preamble.tex`** | Introduce `\begin{trapbox}` styling, color palettes, and unified macros across all books. |
| **Phase 2** | **Statistics for Data Science 2 (`stats2`)** | **Highest leverage.** Update Weeks 1–12 with parameter estimation gotchas (boundary MLEs, score/Fisher information, invariance), $p$-value fallacies, comparative synthesis matrices, and Tier-2 diagnostic MCQs. |
| **Phase 3** | **Statistics for Data Science 1 (`stats1`)** | Update Weeks 1–12 with probability fallacies, Bayes gotchas, discrete/continuous distribution boundary conditions, and Tier-2 diagnostic questions. |
| **Phase 4** | **Mathematics for Data Science 1 & 2 (`maths1`, `maths2`)** | Infuse linear algebra and calculus gotchas (e.g., invertibility traps, subspace vs. subset, gradient vs. directional derivative). |
| **Phase 5** | **Python for Data Science (`python`)** | Infuse Pythonic gotchas (mutable default arguments, shallow vs. deep copy, broadcasting nuances in NumPy, floating-point precision). |
| **Phase 6** | **Compilation & Verification** | Run `compile_all.ps1` to ensure every PDF builds cleanly with zero undefined references or layout overflows. |
