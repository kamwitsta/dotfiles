\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myExam}



% formatting ======================================================================================================================================================================


\LoadClass{article}

% margins
% \usepackage[a5paper,landscape,margin=1cm,bmargin=1.5cm]{geometry}
% \usepackage[a5paper,margin=1cm,bmargin=1.5cm]{geometry}
\usepackage[a4paper,margin=1cm,bmargin=2cm]{geometry}

% no header or footer
\AtBeginDocument{\pagestyle{empty}}

% no indent
\setlength{\parindent}{0cm}

% title
\gdef\@points{}
\newcommand{\points}[2]{\gdef\@pointsN{#1}\gdef\@pointsT{#2}}
\newcommand{\myMaketitle}{
	{\Large \addfontfeature{Letters=SmallCaps} \@title} \hfill \@date \par
	\vskip .1cm
	Imię i nazwisko: \hfill /\@pointsN\ \@pointsT
	\vskip 1cm
}

% different spacing in lists
\AtBeginDocument{
\usepackage{enumitem}
\newenvironment{examEnum}{
	\begin{enumerate}[leftmargin=*, itemsep=1.5\baselineskip]
}{
	\end{enumerate}}
}

% proper tables
\usepackage{booktabs}
