MAIN=PuppetHPCConfiguration.asc

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
	asciidoctor -a data-uri -d book -b html5 -o $@ $(@:.html=.asc)

pdf: PuppetHPCConfiguration.pdf

.PHONY: PuppetHPCConfiguration.pdf
PuppetHPCConfiguration.pdf: $(PICS) $(GRAPH_PUPPET)
	asciidoctor -d book -T backend-edf-latex -o $(@:.pdf=.tex) $(@:.pdf=.asc)
	rubber --pdf $(@:.pdf=.tex)

clean:
	-rubber --clean $(MAIN:.asc=.tex)
	-rm -f *.html *.tex *.pdf $(wildcard $(GRAPH_PUPPET) $(PICS))

