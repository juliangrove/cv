with import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz) { };
let
  orgEmacs = emacsWithPackages (with emacsPackagesNg; [ ]);
  orgEmacsConfig = writeText "default.el" ''
    (add-to-list 'load-path "${emacsPackages.org-ref}")
    (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
          '("cv"
           "\\documentclass[a4paper,10pt]{article}
       %A Few Useful Packages
       \\usepackage{marvosym}
       % \\usepackage{fontspec} 					%for loading fonts
       % \\usepackage{url,parskip} 	%other packages for formatting
       \\usepackage{xunicode,xltxtra,url,parskip} 	%other packages for formatting
       \\RequirePackage{color,graphicx}
       \\usepackage[usenames,dvipsnames]{xcolor}
       \\usepackage[big]{layaureo} 				%better formatting of the A4 page
       % an alternative to Layaureo can be ** \\usepackage{fullpage} **
       \\usepackage{supertabular} 				%for Grades
       \\usepackage{titlesec}					%custom \\section
       \\usepackage{multirow}
       \\usepackage{makecell}
       \\usepackage{array}
       \\usepackage{units}
       \\usepackage{float}
       \\usepackage{lastpage}
       \\usepackage{longtable}
       \\usepackage{dashrule}
       %Setup hyperref package, and colours for links
       \\usepackage{hyperref}
       \\definecolor{linkcolour}{rgb}{0,0.2,0.6}
       \\hypersetup{colorlinks,breaklinks,urlcolor=linkcolour,linkcolor=linkcolour}


       %CV Sections inspired by:
       %http://stefano.italians.nl/archives/26
       \\titleformat{\\section}{\\Large\\scshape\\raggedright\\sffamily}{}{0em}{}[\\titlerule]
       \\titlespacing{\\section}{0pt}{3pt}{3pt}
       %\\titlespacing{\\section}{0pt}{2pt}{2pt}
       \\titleformat{\\subsection}{\\bfseries\\raggedright\\sffamily}{}{0em}{}[]
       %Tweak a bit the top margin
       %\\addtolength{\voffset}{-1.3cm}

       %Italian hyphenation for the word: \'\'corporations\'\'
       \\hyphenation{im-pre-se}

       %-------------WATERMARK TEST [**not part of a CV**]---------------
       \\usepackage[absolute]{textpos}

       \\setlength{\\TPHorizModule}{30mm}
       \\setlength{\\TPVertModule}{\\TPHorizModule}
       \\textblockorigin{2mm}{0.65\\paperheight}
       \\setlength{\\parindent}{0pt}



       %FONTS
       \\defaultfontfeatures{Mapping=tex-text}
       % \\setmainfont[SmallCapsFont = Fontin SmallCaps]{Fontin}
       %%% modified for Karol Kozioł for ShareLaTeX use
       \\setmainfont[
       BoldFont = Cochineal-Bold.otf,
       ItalicFont = Cochineal-Italic.otf
       ]
       {Cochineal-Roman.otf}
       \\setsansfont[
       %SmallCapsFont = LinBiolinum_aS.ttf,
       BoldFont = LinBiolinum_RB.otf,
       ]
       {LinBiolinum_R.otf}
       %%%

       \\usepackage{fancyhdr}
       \\pagestyle{fancy}
       \\fancyhf{}
       \\renewcommand{\\headrulewidth}{0pt}
       \\lfoot{Julian Grove}
       \\rfoot{\\today}
       [NO-DEFAULT-PACKAGES]
       [PACKAGES]
       [EXTRA]"
              ("\\section{%s}" . "\\section*{%s}")
              ("\\subsection{%s}" . "\\subsection*{%s}")
              ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
  '';
  libertineotfPkg = { stdenv }:
    stdenv.mkDerivation rec {
      name = "libertineotf";

      src = fetchzip {
        url = "https://mirrors.ctan.org/obsolete/fonts/libertineotf.zip";
        sha256 = "sha256-+/EkvQtGeUpfPDgqKUsDzNfcnr/xyV3aU/jrM5Q7R/4=";
      };

      passthru = {
        tlType = "run";
        pname = "texmf-dist";
      };

      phases = [ "unpackPhase" "installPhase" ];

      installPhase = ''
        mkdir -p $out
        cp -r doc $out
        cp -r fonts $out
        cp -r source $out
        cp -r tex $out
      '';
    };
in
stdenv.mkDerivation {
  name = "docsEnv";
  shellHook = ''
    export LANG=en_US.UTF-8
    export MYEMACSLOAD=${orgEmacsConfig}
  '';
  # eval $(egrep ^export ${ghc} /bin/ghc)
  buildInputs = [
    orgEmacs
    (texlive.combine {
      inherit (texlive)
        adjustbox
        cochineal
        collectbox
        dashrule
        doublestroke
        inconsolata
        lastpage
        libertine
        makecell
        mathtools
        multirow
        newtx
        newunicodechar
        realscripts
        scheme-basic
        scheme-tetex
        stmaryrd
        textpos
        tikz-qtree
        tikzsymbols
        tipa
        titlesec
        ulem
        upquote
        ;
      libertineotf.pkgs = [ (pkgs.callPackage libertineotfPkg { }) ];
    })
  ];
}

