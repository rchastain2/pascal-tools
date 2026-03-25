default: fetes.pdf

easter: easter.lpr
	lazbuild $@.lpi

fetes.pdf: fetes.tex easter
	./easter > body.tex
	lualatex $<

clean:
	rm -f *.aux
	rm -f *.log
	rm -f *.lps
	rm body.tex
	rm easter
