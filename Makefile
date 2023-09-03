default:
	nix-shell --pure --run "make cv.pdf"

cv.tex: cv.org
	emacs --batch --eval="(load \"${MYEMACSLOAD}\")" $< -f org-latex-export-to-latex --kill

cv.pdf: cv.tex
	xelatex cv

clean:
	rm -f *.aux *.nav *.tex *.toc *.snm *.pdf *.bbl *.blg *.bcf *.out *.log *~
