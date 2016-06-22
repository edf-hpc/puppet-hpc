MAIN=PuppetHPCConfiguration.txt

DOT=$(shell find . -name '*.dot')
GRAPH_PUPPET=$(patsubst %.dot,%.png,$(DOT))
SVG=$(shell find . -name '*.svg')
PICS=$(patsubst %.svg,%.png,$(SVG))

all: html pdf

html: PuppetHPCConfiguration.html

%.png: %.svg
	inkscape --export-dpi=200 --export-png=$@ -D $<

%.png: %.dot
	dot -Tpng -o$@ $^

.PHONY: PuppetHPCConfiguration.html
PuppetHPCConfiguration.html: $(PICS) $(GRAPH_PUPPET)
	asciidoctor -a data-uri -d book -b html5 -o $@ $(@:.html=.txt)

pdf: PuppetHPCConfiguration.pdf

.PHONY: PuppetHPCConfiguration.pdf
PuppetHPCConfiguration.pdf: $(PICS) $(GRAPH_PUPPET)
	asciidoctor -d book -T backend-edf-latex -o $(@:.pdf=.tex) $(@:.pdf=.txt)
	rubber --pdf $(@:.pdf=.tex)

clean:
	-rubber --clean $(MAIN:.txt=.tex)
	-rm -f *.html *.tex *.pdf $(wildcard $(GRAPH_PUPPET) $(PICS))

