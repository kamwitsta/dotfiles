% mini toc
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myDraft}



% = formatting ==========================================================================


% options
\DeclareOption{eco}{	% default
	\def\cArticle{a4paper,10pt}
	\def\cClass{article}
	\def\cGeometry{margin=1cm,bmargin=1.5cm,twocolumn}
	\def\cLists{leftmargin=*,nosep}
	\def\cParindent{.4cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=0cm}
	\def\cSpread{1}
}
\DeclareOption{article}{
	\def\cArticle{a4paper,10pt}
	\def\cClass{article}
	\def\cGeometry{margin=2cm}
	\def\cLists{leftmargin=*,nosep}
	\def\cParindent{.5cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=\medskipamount}
	\def\cSpread{1}
}
\DeclareOption{article-big}{
	\def\cArticle{a4paper,11pt}
	\def\cClass{article}
	\def\cGeometry{margin=2.5cm}
	\def\cLists{leftmargin=*}
	\def\cParindent{.5cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=\medskipamount}
	\def\cSpread{1.2}
}
\DeclareOption{kindle}{
	\def\cArticle{10pt}
	\def\cClass{article}
	\def\cGeometry{margin=.2cm,paperwidth=9.15cm,paperheight=12.35cm}
	\def\cLists{leftmargin=*,noitemsep}
	\def\cParindent{.5cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=\medskipamount}
	\def\cSpread{1.2}
}
\DeclareOption{sec}{
	\def\cArticle{a4paper,11pt,draft}
	\def\cClass{article}
	\def\cGeometry{bmargin=5.5cm,lmargin=4.25cm,tmargin=5.5cm,rmargin=4.25cm}
	\def\cLists{leftmargin=*,noitemsep}
	\def\cParindent{.5cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=\medskipamount}
	\def\cSpread{1.1}
}
\DeclareOption{widemargin}{
	\def\cArticle{a4paper,12pt}
	\def\cClass{article}
	\def\cGeometry{margin=1.5cm,bmargin=2.5cm,rmargin=7cm,marginparwidth=5cm,marginparsep=1cm}
	\def\cLists{leftmargin=*,noitemsep}
	\def\cParindent{.5cm}
	\def\cQuoting{leftmargin=\cParindent,rightmargin=\cParindent,vskip=\medskipamount}
	\def\cSpread{1.1}
}
\ExecuteOptions{eco}
\ProcessOptions\relax

% page
\LoadClass[\cArticle]{\cClass}
\usepackage[\cGeometry]{geometry}
\linespread{\cSpread}
\usepackage{titlesec}

% column separator
\setlength{\columnsep}{0.8cm}

% header & footer
\usepackage{fancyhdr}
\usepackage{zref-user,zref-lastpage}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\setlength\footskip{20pt}
\fancyfoot[R,RO]{\thepage/\zpageref{LastPage}}
\AtBeginDocument{\pagestyle{fancy}}

% title
\AtBeginDocument{
\renewcommand{\maketitle}{
	\noindent\@author
	\vskip .25cm
	\setlength{\parindent}{0cm}
	{\LARGE \@title \par}
	\vskip 1cm
	\setlength{\parindent}{\cParindent}
}
}

% full stop after section numbers
\makeatletter
\def\@seccntformat#1{\csname the#1\endcsname.\quad}
\def\numberline#1{\hb@xt@\@tempdima{#1\if&#1&\else.\fi\hfil}}
\makeatother

% proper footnotes, even in multicolumn
\usepackage[bottom,hang,multiple,splitrule]{footmisc}
	% \setlength{\footnotemargin}{2.5cm}

% captions
\usepackage[format=hang,singlelinecheck=off]{caption}
\captionsetup{width=.75\textwidth}

% lists
\usepackage[inline]{enumitem}
\expandafter\setlist\expandafter{\cLists}
\setlist[description]{itemindent=-\cParindent,listparindent=\cParindent}
\newlist{references}{description}{1}
\setlist[references]{itemindent=-\cParindent,labelsep=0cm}

% quoting
\AtBeginDocument{
\usepackage{quoting}
\expandafter\quotingsetup\expandafter{\cQuoting}
}

% table of contents (toc)
% \usepackage{titletoc}
% \setcounter{tocdepth}{2}
% \titlecontents*{section}[0cm]{\small}{\b{\thecontentslabel}.~}{}{}[ ‖ ][]
% \titlecontents*{subsection}[0cm]{\small; }{\i{\thecontentslabel}.~}{}{}[; ][]
% \makeatletter
% \newcommand\minitoc{
    % \@starttoc{toc}%
% }
% \makeatother
% \makeatletter
% \def\minitoc{ \minitocHlp }
% \makeatother
% \def\minitocHlp{
	% \begingroup
	% \makeatletter
		% \input{\jobname.toc}
	% \makeatother
	% \endgroup
% }

% variables =======================================================================================================================================================================


% less hyphenation
\hyphenpenalty=100

% much less tolerance for increased spacing
\tolerance=500

% widows and orphans
\clubpenalty=10000
\widowpenalty=10000

% a more reasonable length for the last line
\parfillskip=.50\columnwidth plus .3\columnwidth minus .5\columnwidth
