## Getting Started with LaTeX

LaTeX is a typesetting language.  Unlike programs like MS Word that are mostly WYSIWYG (what you see is what you get), in LaTeX you use markup to define what you want and the typesetting system will produce a professional looking document for you.  The benefit of this approach is that you can focus on content and not formatting.  For example, you may want to switch a manuscript from one journal to another.  Most conferences and journals provide LaTeX style files, so changing the style of the entire document is as easy as changing one line.  Perhaps the more important benefit for us is the ease with which mathematical content can be inserted into a document.  LaTeX is widely used in scientific publishing.

There are several editor options for composing a LaTeX document:

- [Overleaf](https://www.overleaf.com).  Benefits: easy to get started, nothing to install, simple collaborations are easy. Downsides: can't use normal text editor features like multicursor, snippets, etc.  Asynchronous/offline collaboration is clunky (though you can get around this with git).  There are limitations on the maximum number of collaborators.
- Any decent text editor + a LaTeX package.  I prefer VSCode with the LaTeX Workshop extension, though I've done the same with Atom and Sublime Text.  The nice thing about using the same text editor that you already use for other programming languages is that all the keyboard shortcuts are the same.  You can also create snippets for common commands like figures, tables, etc.  I've listed some of my common snippets below.
- Another option is TexShop, TeXworks, or other Tex-specific editors.  I used to find these compelling, but given the significant amount of features now available in general text editors that you will use anyway, I no longer see any real benefit.  However, some prefer this option.

To learn syntax, I created an [example](https://www.overleaf.com/latex/examples/a-simple-example-for-me-en-575/tmvvshzxypsj#share) that introduces you to most of the basics.  Online searches can help you will more complex tasks.  Some common snippets I use are shown below:

Figure:
```tex
\begin{figure}[htbp]
\centering
\includegraphics[width=3.0in]{$1}
\caption{$2}
\label{fig:$1}
\end{figure}
```

Subfigure:
```tex
\begin{figure}[htbp]
\centering
\subfloat[$2]{
\includegraphics[width=3.0in]{$1}
\label{fig:$1}
}
\qquad
\subfloat[$4]{
\includegraphics[width=3.0in]{$3}
\label{fig:$3}
}
\caption{$5}
\label{fig:$6}
\end{figure}
```

Table:
```tex
\begin{table}[htb]
\centering
\caption{$1}
\label{tab:$2}
\begin{tabular}{@{}llr@{}}
\toprule
$3 &  &  \\
\midrule
\bottomrule
\end{tabular}
\end{table}
```

Header:
```tex
\documentclass{article}

%\usepackage[margin=1in]{geometry}
%\usepackage{graphicx}
%\usepackage{amsmath}
%\usepackage[noprefix]{nomencl}
%\usepackage[colorlinks,bookmarks,bookmarksnumbered,allcolors=blue]{hyperref}
%\usepackage{cite}
%\usepackage{doi}
%\usepackage[caption=false,justification=raggedright,singlelinecheck=false]{subfig}
%\usepackage{booktabs} % better tables
%\usepackage[capitalise]{cleveref}

\begin{document}

\title{}
\author{Your Name}
\maketitle

\section{}

\end{document}
```


## BibTeX with BibDesk

The example LaTeX document uses a *.bib file to contain your references.  This file uses BibTeX format, but don't worry, there is no need to learn the format.  Plenty of good tools can manage it for you.  On a Mac I recommend [BibDesk](https://bibdesk.sourceforge.io). JabRef appears to be fairly similar for Linux users, though I won't discuss it here.

It differs from reference management systems like Papers or Mendeley in that it is specifically designed for BibTeX.  While I love the idea behind tools like Mendeley, I find that they mess up exported BibTeX files and require a lot of manual cleanup to maintain.  In BibDesk the database is just a BibTeX file.  Below are a few pointers to get you started.

- Create a new bibliography (shift-cmd-n or file > new bibliography).  Save it and give it a name.  Note that the extension is \*.bib.  It is just a BibTeX file, which you can see if you open it in any text editor (after filling it with some publications).  Generally, you only need one bibliography for all of your work.  Occasionally when working with a collaborator you might need a separate bibliography just for that repo.
- Create a new publication (cmd-n or the big green plus button).  Notice in the dropdown menu that you can choose different styles of publications.  These correspond to the recognized types in BibTeX and the corresponding fields automatically update.  If you've never created a BibTeX file manually then you might not appreciate how convenient this is.  
- On the right hand side of this dialog you can drop in files, which is useful for storing the associated PDF. 
- One of the fields is `keywords`.  Keywords don't show up in your LaTeX document, they are purely for your own organizational benefit.  Keywords populate on the left hand side of the app so you can filter by them.  One publication can have multiple keywords.
- You can sort and subsort publications by any of the fields at the top.  Right click on the top to add/remove fields.
- Open preferences (cmd-comma -- the keyboard shortcut to open preferences for almost any Mac app)
    - General: I recommend having it open your new master bibliography file on launch.
    - Tex Preview: You might like to change the BibTeX style to something you use (I have mine set to aiaa)
    - CiteKey: Check the autogenerate box.  You can use one of the preset formats or create a custom one.  Mine is custom, it's exactly the same as the first author + : + year + sufficient unique letters, except that I don't like the colon: `%a1%Y%u0`.  If custom, I'd also leave the box checked for "Clean by removing Tex".
    - AutoFile: I like to have BibDesk move all the PDFs I drag into the app into a central location.  I created a folder for this purpose and chose the option "File papers in fixed location".  For the format string I have a custom one, which is just the citekey + unique number if necessary + the file extension: `%f{Cite Key}%n0%e`
- If you need to move publications from one bibliography to another, you can just drag and drop entries.
- I very rarely enter any entries manually. Instead I import almost all of my references automatically using a script [I wrote](https://github.com/byuflowlab/bibteximport) that pulls from the CrossRef database (actually I use my [Alfred workflow version](https://github.com/andrewning/alfred-workflows-scientific), but it requires Alfred and the powerpack, and that isn't free).
- Even data from crossref, using the above script, sometimes needs some cleanup.  There are various scripts you can find online that are helpful in cleaning up BibDesk data (search BibDesk and Applescript).  When you install these they can be run from the little script menu within BibDesk.  A few I use are "Capitalize Authors", "Capitalize Titles", "Shorten Months", "Add Keyword".
- To use in a LaTeX document just add the following two lines at the bottom of your document (but before `\end{document}`):
    ```tex
    \bibliographystyle{aiaa}  % depending on journal style
    \bibliography{/path/to/bib/file}  % path to bib file w/o extension
    ```
- Cite the reference in your document using its unique citekey `\cite{CiteKey}`. 

