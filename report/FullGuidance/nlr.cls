% This class file provides basic functionality for producing
% PDFs that meet NLR's style and formatting requirements.

% -------------------------------------------------------------
% Identification Part
% -------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{NLR}
% Define version and date once for reuse
\newcommand{\NLRversion}{v2.2.0}
\newcommand{\NLRdate}{February 2026}
\typeout{ }
\typeout{NLR.cls -- \NLRversion, \NLRdate}
\typeout{Formats documents according to the NLR style guide}
\typeout{ }

% -------------------------------------------------------------
% Create Options
% -------------------------------------------------------------
%% PDF properties
% \pdfinterwordspaceon disabled -- causes text overlap with URW Helvetica (phv)
% in pdfTeX 1.40.27 (TeX Live 2025), especially inside minipages and fancyhdr boxes.
% TL2025's LaTeX Tagging Project provides better accessibility support.
% \ifdefined\pdfinterwordspaceon\pdfinterwordspaceon\fi
% for processing of conditional statements
\RequirePackage{xifthen}
% Mark as draft
\newboolean{IsDraft}
\setboolean{IsDraft}{false}
% print links in black
\newboolean{blacklinks}
\setboolean{blacklinks}{false}
% Set flag to meet NLR template requirements
% true by default
\newboolean{IsNLR}
\setboolean{IsNLR}{true}
% Set flag to meet EERE template requirements
\newboolean{IsEERE}
\setboolean{IsEERE}{false}
% Set flag for confidentiality statement
\newboolean{IsConfidential}
\setboolean{IsConfidential}{false}
% tagged?
\newboolean{IsTagged}
\setboolean{IsTagged}{false}
% single appendix?
\newboolean{IssingleAppendix}
\setboolean{IssingleAppendix}{false}

% -------------------------------------------------------------
% Check for choice of package and formatting options
% -------------------------------------------------------------
% look out for draft
\DeclareOption{draft}{
	\setboolean{IsDraft}{true}
	\typeout{Formatting as draft}
	}
% If EERE option is set, format as EERE template
\DeclareOption{EERE}{
	\setboolean{IsEERE}{true}
	\setboolean{IsNLR}{false}
	\def\NLR@class{report}
	\typeout{Using EERE report template}
}
% NLR is assumed to be true by default
% unless switched off by EERE flag
\ifthenelse{\boolean{IsNLR}}{ 
	\def\NLR@class{report}
	\typeout{Using NLR report template}
}{}
% If tagged option is set, format as tagged pdf
\DeclareOption{tagged}{
	\setboolean{IsTagged}{true}
	\typeout{PDF will be tagged}
	}
% If confidential option is set, add confidentiality statement
\DeclareOption{confidential}{
	\setboolean{IsConfidential}{true}
	\typeout{Confidentiality statement added to title page and headers}
	}
% report has single appendix, change formatting
\DeclareOption{singleAppendix}{
	\setboolean{IssingleAppendix}{true}
	\typeout{Changing format for single appendix}
	}

% -------------------------------------------------------------
% Process Options
% -------------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\NLR@class}}
\ExecuteOptions{12pt}
\ProcessOptions\relax
\LoadClass{\NLR@class}

% -------------------------------------------------------------
% Package Loading
% -------------------------------------------------------------

% titlepage stu
\RequirePackage{titling}
\RequirePackage{datetime}
\newdateformat{monthyeardate}{%
  \monthname[\THEMONTH], \THEYEAR}
% for multiple authors/affils
\RequirePackage{authblk}
% GEOMETRY: set page size
\RequirePackage[letterpaper, top=0.5in,bottom=1in,inner=1in,outer=1in,includefoot,headsep=6em]{geometry}
% Times for roman text and math (newtx replaces obsolete mathptmx)
\RequirePackage{newtxtext}
\RequirePackage{newtxmath}
% Helvetica for sans serif (family phv)
\RequirePackage[scaled=0.83]{helvet}
% Courier for typewriter font (family pcr)
\RequirePackage{courier}
% ams math (amsfonts/amssymb removed -- newtxmath provides all AMS symbols)
\RequirePackage{amsmath}
% gensymb. Required for degrees symbol
\RequirePackage{gensymb}
% acronyms
\RequirePackage{acronym}
\renewcommand*\aclabelfont[1]{\acsfont{#1}}
% Prevent orphan lines and windows
\RequirePackage[all]{nowidow}
% % better tables
\RequirePackage{booktabs}
% \RequirePackage{tabularx}
% For including figures, ignoring the draft status
\RequirePackage[final]{graphicx}
% use fonts of type T1
\RequirePackage[T1]{fontenc}
% colours
\RequirePackage{xcolor}
\definecolor{NLRblue}{RGB}{0, 121, 193}
% set languages
\RequirePackage[english]{babel}
% To stop hyphenation in titles etc
\RequirePackage{hyphenat}
% prevent hyphenation across page break
\brokenpenalty10000\relax
% spacing
\RequirePackage{setspace}
\RequirePackage{parskip}
% ragged2e, tocloft, tocbibind must load BEFORE biblatex-chicago.
% biblatex loads nameref which redefines \@starttoc (breaks tocloft)
% and \@arrayparboxrestore (breaks ragged2e minipage handling).
\RequirePackage[newcommands,document]{ragged2e}
\setlength{\RaggedRightRightskip}{0pt plus 3em}
\RequirePackage[titles]{tocloft}
\RequirePackage[nottoc, notlot, notlof]{tocbibind}
% to-do notes
\RequirePackage{todonotes}
% code listings
\RequirePackage{listings}
\RequirePackage{etoolbox}
% titlesec removed -- incompatible with TeX Live 2025; appendix headings use native commands
\RequirePackage[title,titletoc]{appendix}
%% ----------------------------
%% References section 
%% ----------------------------
% For formatting the bibliography. See guidance 
\RequirePackage[babel]{csquotes}
\usepackage[authordate,
            backend=biber,
			natbib,
			bibencoding=inputenc,
			sorting=nyt,
			doi=true, 
			maxbibnames=10,
			giveninits=true, 
			maxcitenames=3,
            ]{biblatex-chicago}
% change the name of the bib 
% (see http://tex.stackexchange.com/questions/82993/how-to-change-the-name-of-document-elements-like-figure-contents-bibliogr)
\DefineBibliographyStrings{american}{%
  bibliography = {References},
}
% No indentation
\setlength{\bibhang}{0pt}
% bibitemsep = 12 pt
\setlength{\bibitemsep}{8pt}

% fix spacing between heading and references
\AtBeginBibliography{
	% \titleformat{\chapter}{\fontsize{18pt}{0pt}\bfseries\selectfont}
	% \vspace*{12pt}
	}
% see NLR formatting guidelines at 
% https://communications_resources.NLR.gov/style_guide/references
% technical reports
\DeclareBibliographyAlias{techreport}{book}
% make one type of publication look like another
% map unknown bibliography entry types to the misc type
\DeclareBibliographyAlias{*}{misc} 
% make sure URLs in the bibliography are shown in roman fonts
\urlstyle{same}

% --------------------------------------------------------
% Main Code
% --------------------------------------------------------

% -------------------------------------------
% Changes to TOC and list of figures/tables
% -------------------------------------------
% (tocloft, tocbibind, ragged2e loaded earlier -- before biblatex)

% add Figure before # and a period after
\renewcommand{\cftfigfont}{\sffamily Figure }
\renewcommand{\cfttabfont}{\sffamily Table }
\renewcommand{\cftfigaftersnum}{.}
\renewcommand{\cfttabaftersnum}{.}

% TOC entry fonts (title fonts handled by \@makeschapterhead with [titles] option)
\renewcommand{\cftchapfont}{\fontsize{10}{12}\selectfont\sffamily\bfseries}
\renewcommand{\cftsecfont}{\fontsize{11}{13}\selectfont}
\renewcommand{\cftsubsecfont}{\fontsize{11}{13}\selectfont}

% linespacing in the TOC
\setlength\cftparskip{-2pt}
\setlength\cftbeforechapskip{2pt}
\setlength\cftbeforesecskip{2pt}
\setlength\cftbeforesubsecskip{2pt}

% Rename the title of contents
\addto{\captionsenglish}{\renewcommand*{\contentsname}{Table of Contents}}
% add dotfill in toc
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}

% remove indentation
\setlength{\cftfigindent}{0pt}
\setlength{\cfttabindent}{0pt}

% don't add extra spaces in list of figures between chapters
\newcommand*{\noaddvspace}{\renewcommand*{\addvspace}[1]{}}
\addtocontents{lof}{\protect\noaddvspace}
\addtocontents{lot}{\protect\noaddvspace}
\setlength{\cftbeforefigskip}{5pt}
\setlength{\cftbeforetabskip}{5pt}

% -------------------------------------------
% Changes to the chapter and section markings
% -------------------------------------------
% Chapter Headings
\renewcommand{\@makechapterhead}[1]{%
	\vspace*{-20\p@}%
	{\color{NLRblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
	\ifnum \c@secnumdepth >\m@ne
		\sffamily\bfseries\fontsize{18}{21}\selectfont
		\thechapter \hspace*{1em}#1
		\else
		\sffamily\bfseries\fontsize{18}{21}\selectfont #1
	\fi
	\par\nobreak
	% \vspace*{0pt}
	}}
\renewcommand{\@makeschapterhead}[1]{%
	\vspace*{-20\p@}%
	{\color{NLRblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
	\Large\sffamily\bfseries #1
	\par\nobreak
	% \vspace*{-12pt}
	}
	}

% Section Headings
\renewcommand{\section}{%
	\@startsection{section}{1}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{NLRblue}\sffamily\bfseries\fontsize{14}{17}\selectfont}}
\renewcommand{\subsection}{%
	\@startsection{subsection}{2}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{NLRblue}\sffamily\bfseries\slshape}}
\renewcommand{\subsubsection}{%
	\@startsection{subsubsection}{3}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\color{NLRblue}\sffamily\normalsize\itshape}}
\renewcommand{\paragraph}{%
	\@startsection{paragraph}{4}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\bfseries\normalsize}}
\renewcommand{\subparagraph}{%
	\@startsection{subparagraph}{5}{\z@}
	{-3.25ex \@plus -1ex \@minus -.2ex}
	{0.25ex \@plus .2ex}
	{\bfseries\normalsize\itshape}}

% inherit fonts etc from TOC
\let\printlottitle\printtoctitle
\let\printloftitle\printtoctitle

% % Format Captions
% % see e.g. http://www.peteryu.ca/tutorials/publishing/latex_captions for details of how to adjust
\RequirePackage{caption}
\RequirePackage{subcaption}
\captionsetup[table]{font={small,sf,bf},
	labelfont={small,sf,bf},
	textfont={small,sf,bf},
	position=above,
	labelsep=period,
	justification=centering,
	singlelinecheck=true,
	aboveskip=0pt,
	belowskip=0pt}
\captionsetup[figure]{font={small,sf,bf},
	labelfont={small,sf,bf},
	textfont={small,sf,bf},
	position=below,
	labelsep=period,
	justification=centering,
	singlelinecheck=true,
	belowskip=0pt,
	aboveskip=0pt}

% number figures and tables continuously across chapters
% chngcntr removed -- \counterwithout/\counterwithin are LaTeX kernel built-ins since 2018
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{footnote}{chapter}

\RequirePackage{footmisc}
\renewcommand{\footnotelayout}{\fontsize{10}{12}\selectfont}
\renewcommand{\footnoterule}{% Kerns avoid vertical space
  \kern -3pt                         % This -3 is negative
  \hrule width 0.3\textwidth height 0.4pt % of the sum of this 1
  \kern 10pt}                         % and this 2

% Note that if we use the front matter / main matter, we have to change numbers
% need to renew the front, main, and back matter commands
\newcommand{\frontmatter}{%
		\renewcommand\thechapter{\hspace{-1.65ex}}
		\pagenumbering{roman} %
		\setcounter{page}{3} %
		\setcounter{figure}{0} %
		\renewcommand{\thefigure}{ES-\arabic{figure}} %
		\setcounter{table}{0} %
		\renewcommand{\thetable}{\Alph{table}}
	}
	\newcommand{\mainmatter}{%
		\clearpage %
		\renewcommand\thechapter{\arabic{chapter}}
		\setcounter{chapter}{0} %
		\pagenumbering{arabic} %
		\setcounter{figure}{0} %
		\renewcommand{\thefigure}{\arabic{figure}} %
		\setcounter{table}{0} %
		\renewcommand{\thetable}{\arabic{table}}%
		\setlength\parskip{8pt}
	}
	\newcommand{\backmatter}{}

% deal with the appendix
\renewcommand\appendix{\par
	\setcounter{chapter}{0} 
	\setcounter{section}{0}
	\setcounter{footnote}{0} 
	% change chapter numbering to letters
	\renewcommand{\thechapter}{\Alph{chapter}}
	% counters should reset each chapter
	\counterwithin{figure}{chapter}
	\counterwithin{table}{chapter}
	% format figures and tables with appendix letter
	\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
	\renewcommand{\thetable}{\thechapter-\arabic{table}}
	% footnote formatting
	\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
}

\ifthenelse{\boolean{IssingleAppendix}}{ % true
	% --- Native chapter heading overrides for single appendix (no titlesec) ---
	\newcommand{\NLR@appchapterhead@starred}[1]{%
		\vspace*{-20\p@}%
		{\color{NLRblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
		\sffamily\bfseries\fontsize{18}{21}\selectfont
		Appendix\hspace{11pt}#1
		\par\nobreak}}
	\AtBeginEnvironment{appendices}{
		\let\@makeschapterhead\NLR@appchapterhead@starred
		% change chapter numbering to letters
		\renewcommand{\thechapter}{\Alph{chapter}}
		% counters should reset each chapter
		\counterwithin{figure}{chapter}
		\counterwithin{table}{chapter}
		% format figures and tables with appendix letter
		\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
		\renewcommand{\thetable}{\thechapter-\arabic{table}}
		} %<--------- Use this if only one appendix	
	\newcommand{\appchapter}[1]{
	\setcounter{chapter}{1}% Manually set counter for single appendix
	\chapter*{Appendix\hspace{11pt} #1}
    \addcontentsline{toc}{chapter}{{#1}}}
	}
	{% False
	% --- Native chapter heading overrides for multiple appendices (no titlesec) ---
	\newcommand{\NLR@appchapterhead@numbered}[1]{%
		\vspace*{-20\p@}%
		{\color{NLRblue} \parindent \z@ \raggedright \normalfont \interlinepenalty\@M
		\sffamily\bfseries\fontsize{18}{21}\selectfont
		Appendix \thechapter.\hspace{11pt}#1
		\par\nobreak}}
	\AtBeginEnvironment{appendices}{
		\let\@makechapterhead\NLR@appchapterhead@numbered
		% change chapter numbering to letters
		\renewcommand{\thechapter}{\Alph{chapter}}
		% counters should reset each chapter
		\counterwithin{figure}{chapter}
		\counterwithin{table}{chapter}
		% format figures and tables with appendix letter
		\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
		\renewcommand{\thetable}{\thechapter-\arabic{table}}
		  } %<--------- Use this if more than one appendix
	\newcommand{\appchapter}[1]{
		\chapter{#1}}
	}


% Indenting and spacing between paragraphs
\setlength{\parindent}{0pt}

%-----------------------
% GENERAL CODE
%-----------------------
% Require at least 3 characters before a hyphenation.
\lefthyphenmin=3

% Don't hyphenate the months (or any proper noun---other proper nouns must be addressed in the tex file
\hyphenation{January February April July August September October December Department Energy National Laboratory Rockies Washington Colorado Standard}

% Enumerate list environment -- change the default numbering to match our style
\renewcommand{\theenumi}{\arabic{enumi}}
\renewcommand{\theenumii}{\Alph{enumii}}
\renewcommand{\theenumiii}{\roman{enumiii}}
\renewcommand{\theenumiv}{\alph{enumiv}}
\renewcommand{\labelenumi}{\theenumi.}
\renewcommand{\labelenumii}{\theenumii.}
\renewcommand{\labelenumiii}{\theenumiii.}
\renewcommand{\labelenumiv}{\theenumiv)}

% Draft mode
\ifthenelse{\boolean{IsDraft}}{ % tue
	\RequirePackage{draftwatermark}
	\SetWatermarkAngle{60}
	\SetWatermarkLightness{0.875}
	\SetWatermarkFontSize{6cm}
	\setboolean{blacklinks}{false}
	}{% False
	}


% pdfcomment removed -- incompatible with TeX Live 2025 tagging changes
% \RequirePackage[linewidth = 0]{pdfcomment}

%% ----------------------------
%% ACCESSIBILITY
%% ----------------------------
% accessibility package removed -- obsolete, superseded by LaTeX Tagging Project

% need to add page number and availability information to every page, including new chapters.
\RequirePackage{fancyhdr}
% \fancyhf{} % clear all header and footer fields
\ifthenelse{\boolean{IsConfidential}}{%IsConfidential==True
	\fancypagestyle{NLR}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0pt}
	\fancyfoot[C]{\thepage\\\vspace{1em} \textbf{The contents of the report are confidential} }}
}{%IsConfidential==False
	\fancypagestyle{NLR}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0pt}
	\fancyfoot[C]{\thepage\\\vspace{1em} \small\sffamily \textcolor{lightgray}{This report is available at no cost from the National Laboratory of the Rockies (NLR) at http://www.nlr.gov/publications.}}
}
	
}

\appto\frontmatter{\pagestyle{NLR}}                                       
\appto\mainmatter{\pagestyle{NLR}}                                        
\appto\backmatter{\pagestyle{empty}}   

% Ensure chapter opening pages also use the NLR footer (\chapter calls \thispagestyle{plain})
\fancypagestyle{plain}[NLR]{}



%% command to scrape authors from authblk (without affils or markers)
\RequirePackage{xstring}
\RequirePackage{hyperref}

\typeout{AB@authlist}
\pdfstringdef\cleanlist{\AB@authlist}
\StrDel{\cleanlist}{1}[\cleanlist]
\StrDel{\cleanlist}{2}[\cleanlist]
\StrDel{\cleanlist}{3}[\cleanlist]
\StrDel{\cleanlist}{4}[\cleanlist]
\StrDel{\cleanlist}{5}[\cleanlist]

%% add pdf title and authors
\typeout{\cleanlist}
\hypersetup{
	final, 
	linktocpage, 
	colorlinks=false, 
	linktoc=all, 
	linkcolor=black, 
	citecolor=NLRblue, 
	menucolor=black, 
	urlcolor=NLRblue, 
	pdfborder={0 0 0},
	unicode, 
	pdflang={en-US},
	pdftitle=\@title,
	pdfauthor={Nicholas Hamilton},
	hypertexnames=false,
	bookmarksnumbered
	% pdfauthor={\cleanlist}
}


%% format of make title (title, authors, affils)
	\renewcommand{\maketitle}{\bgroup\setlength{\parindent}{0pt}
	\null
	\vskip 2em%
	\begin{flushright}
		{\sffamily\bfseries\fontsize{25}{30}\selectfont
		\@title}%
		\vskip 1.5em%
		{\sffamily\fontsize{12}{14}\selectfont
		\@author}%
		\vskip 1em%
	\end{flushright}
	\egroup
	}

%% THINGS WE NEED TO DO AT THE START OF THE DOCUMENT
\AtBeginDocument{
	% headsep now set in \geometry options

	% -------------------------------------
	% hard-coded formatting for title page
	% * no changes needed *
	% -------------------------------------
	\thispagestyle{empty}		
	\centering
	% \vspace*{-8em}
	% \includegraphics[width=\textwidth]{header}\\
	\vspace*{4em}
	\begin{flushright}
		\begin{minipage}{0.7\textwidth}
			\maketitle			
		\end{minipage}
		\\	
		\vfill
		\begin{minipage}[b]{0.75\textwidth}
			\begin{minipage}[b]{0.7\textwidth}
				This is a temporary cover page.
				A final cover page will be generated by comms with current style and formatting.\\
				\vspace{2ex}
				\textbf{\NLRversion, \NLRdate}
			\end{minipage}
		\end{minipage}
	\end{flushright}
	\raggedright	
% 	\clearpage
}

% end of file
