#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

replace_contents = {
"\documentclass{article}":"\documentclass[10pt,a4paper]{article}",
"\\usepackage[urlcolor=blue,colorlinks=true]{hyperref}":
"""
\\usepackage[unicode,urlcolor=blue,colorlinks=true]{hyperref}
\\renewcommand\contentsname{目录}
\\usepackage{listings}
\\usepackage{fancyvrb}
\\usepackage{xcolor}
\\usepackage{zhtexfont}
\\lstset{
breaklines=tr,
backgroundcolor=\color[rgb]{0.95,1.0,1.0},
frame=shadowbox, framexleftmargin=2mm, rulesepcolor=\\color{red!20!green!20!blue!20!},
extendedchars=false}
""",
#  "\\maketitle\n\\clearpage":"\\maketitle\n\\clearpage\n\\tableofcontents\n\\clearpage",
#  "\\maketitle\n\\clearpage":"\\tableofcontents\n\\clearpage",
#  "includegraphics": "includegraphics[width=0.95\\textwidth,height=0.60\\textheight,keepaspectratio]",
#  "includegraphics": "includegraphics[scale=1]",
"includegraphics": "includegraphics[scale=0.46]",
#  "verbatim": "lstlisting",
"verbatim": "Verbatim",
"begin{Verbatim}": "begin{Verbatim}[frame=single,fontsize=\\small]",
".png}": ".eps}",
".jpg}": ".eps}",
#  "begin{Verbatim}": "begin{Verbatim}[frame=single,fillcolor=\\color{red}]",
#  "$\\backslash$setcounter\\{chapter\\}\\{0\\}": "\\setcounter{chapter}{0}",
#  "subsection*": "chapter",
#  "section*": "part",
}

if __name__ == '__main__':
    input_file, output_file = sys.argv[1:3]
    content = open(input_file, "rt").read()
    for (src, dst) in replace_contents.items():
        content = content.replace(src, dst)
    open(output_file, "wt").write(content)

