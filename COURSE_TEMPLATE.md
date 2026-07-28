# IITM BS Course Textbook Expansion Template

This document provides the blueprint for expanding any set of sparse revision notes for the IITM BS Degree into a full, interactive, beginner-friendly textbook. It captures the workflow, directory structure, LaTeX styling, and video-extraction pipeline used successfully for the Maths 1 course.

---

## 1. Directory Structure
For any new course (e.g., `stats1`, `python`, `maths2`), initialize the following directory structure:

```text
iitm-bs/
└── <course_name>/
    ├── main.tex              # The driver file tying everything together
    ├── preamble.tex          # Contains the custom tcolorbox styling (videocard, etc.)
    ├── appendix.tex          # Centralized location for all step-by-step solutions
    └── chapters/
        ├── week01.tex        # Week 1 Content
        ├── week02.tex        # Week 2 Content
        └── ...
```

---

## 2. LaTeX Preamble & Styling Setup (`preamble.tex`)
To maintain a cohesive visual identity across all textbooks, include the following custom `tcolorbox` environments and packages in your `preamble.tex`. Ensure you have `\usepackage{tcolorbox}`, `\usepackage{hyperref}`, `\usepackage{qrcode}`, `\usepackage{imakeidx}`, `\usepackage{listings}`, `\usepackage{pgfplots}` (with `\pgfplotsset{compat=1.18}`), `\usepackage{venndiagram}`, and `\tcbuselibrary{skins}` loaded.

```latex
% --- Video Card Environment (with QR for print) ---
\newtcolorbox{videocard}[2]{
    enhanced, colback=red!5!white, colframe=red!75!black, fonttitle=\bfseries,
    title={📺 Video: \href{#2}{\color{white}\underline{#1}} \hfill \raisebox{-1.5mm}{\qrcode[height=0.6cm]{#2}}},
    attach boxed title to top left={yshift=-2mm, xshift=5mm},
    boxed title style={colback=red!75!black}
}

% --- Core Concept Environments ---
\newtcolorbox{definitionbox}[1]{
    colback=blue!5!white, colframe=blue!75!black, fonttitle=\bfseries, title={#1}
}
\newtcolorbox{theorembox}[1]{
    colback=green!5!white, colframe=green!50!black, fonttitle=\bfseries, title={#1}
}
\newtcolorbox{examplebox}[1]{
    colback=orange!5!white, colframe=orange!75!black, fonttitle=\bfseries, title={Example: #1}
}

% --- Semantic Macros ---
\newcommand{\set}[1]{\left\{#1\right\}}

% --- Python Code Snippets Styling ---
\definecolor{codegreen}{HTML}{10B981}
\definecolor{codegray}{HTML}{6B7280}
\definecolor{codepurple}{HTML}{8B5CF6}
\definecolor{codebg}{HTML}{F8FAFC}
\lstdefinestyle{pystyle}{
    backgroundcolor=\color{codebg},   
    commentstyle=\color{codegray}\itshape,
    keywordstyle=\color{codepurple}\bfseries,
    stringstyle=\color{codegreen},
    basicstyle=\ttfamily\footnotesize,
    breaklines=true,                 
    frame=single,
    rulecolor=\color{red!75!black}
}
\lstset{style=pystyle}
```

*Note: Remember to include `\makeindex` before `\begin{document}` and `\printindex` at the end of your `main.tex`. To handle dynamic sizing of mathematical delimiters, always use semantic macros (e.g., `\set{x}`) within the chapters instead of manually escaping brackets (e.g., `\{x\}`).*

---

## 3. Video Extraction Pipeline (yt-dlp)
The IITM BS degree relies heavily on video lectures. Before expanding the chapters, extract the full list of video URLs and titles from the official YouTube playlist so they can be accurately embedded as `videocard`s.

**Requirement:** Ensure `yt-dlp` is installed on your system.

Run the following command in PowerShell/Bash to dump the playlist metadata into a JSON file:
```bash
yt-dlp -J --flat-playlist "YOUR_PLAYLIST_URL" > playlist.json
```

Next, use a simple Python script to parse the JSON and generate a mapping file (e.g., `lectures.md`):
```python
import json

with open("playlist.json", "r", encoding="utf-8") as f:
    data = json.load(f)

with open("lectures_mapping.md", "w", encoding="utf-8") as out:
    out.write("# Lecture Video Mapping\n\n")
    for entry in data.get("entries", []):
        title = entry.get("title")
        url = entry.get("url")
        out.write(f"- [{title}]({url})\n")
```
*Note: You can skip tutorials and only map formal lectures if desired.*

---

## 4. Chapter Expansion Template (`weekXX.tex`)
When expanding a weekly chapter, strictly adhere to this logical flow:

1. **Chapter Introduction:** 1-2 paragraphs introducing the core concept.
2. **Theory & Definitions:** Use `\begin{definitionbox}` and `\begin{theorembox}` to break down the math/logic step-by-step. Avoid making it a dry summary; write it as an approachable textbook.
3. **Indexing:** Liberally use `\index{Term}` tags next to important keywords and definitions so they appear in the final glossary.
4. **Data Science Relevance & Code Snippets:** Always include an explicit paragraph (often bolded as **Data Science Relevance:**) explaining *why* a Data Science student needs this concept. Support this with practical Python/NumPy code snippets using the `lstlisting` environment to demonstrate the math in code.
5. **Primary Video Embeds:** Insert `\begin{videocard}` environments immediately after major topic explanations. This positions the text as the primary source of truth, with the video acting as a robust fallback.
    *   *External Fallbacks:* If the official IITM playlist is missing formal lectures for a core topic (or if a concept desperately needs visual intuition), it is highly encouraged to embed gold-standard external videos (e.g., 3Blue1Brown, Khan Academy, Abdul Bari) to maintain the textbook's pedagogical quality.
6. **Supplementary Videos Section:** At the end of the chapter, list any highly specific, niche, or tutorial lectures that didn't fit organically into the main text as a bulleted list of hyperlinks.
7. **Practice Exercises:** Conclude with 5-6 practice problems mixing pure theory calculations with applied Data Science scenarios. *Do not include solutions here.*
8. **Appendix Routing:** Remind the reader that step-by-step solutions are in the Appendix. Write those solutions explicitly in `appendix.tex`.

### Example Chapter Structure
```latex
\chapter{Topic Name}

Introduction paragraph...

\section{Core Concept 1}
Detailed explanation...
\begin{definitionbox}{Definition Name}
   ...
\end{definitionbox}

\textbf{Data Science Relevance:} How this applies to ML/Data Science...

\begin{videocard}{IITM BS Lecture: Topic Name}{https://youtube.com/watch?v=XXXX}
Brief description of what the video covers.
\end{videocard}

\section*{Supplementary Lecture Videos}
\begin{itemize}
    \item \href{url}{WXX_LXX: Niche Topic}
\end{itemize}

\newpage
\section{Practice Exercises}
\textit{Detailed step-by-step solutions are available in the Appendix.}
\begin{enumerate}
    \item Pure theory question...
    \item Data Science application question...
\end{enumerate}
```
