### Makefile --- Generic Makefile for LaTeX classes and styles

## Copyright (C) 2000, 2001, 2002, 2003, 2004 Didier Verna.

## PRCS: $Id: Makefile 1.23 Wed, 22 Dec 2004 15:38:47 +0100 didier $

## Author:        Didier Verna <didier@lrde.epita.fr>
## Maintainer:    Didier Verna <didier@lrde.epita.fr>
## Created:       Thu Sep 23 17:27:00 1999
## Last Revision: Tue Nov  9 17:47:36 2004

### Commentary:

## Contents management by FCM version 0.1.


### Code:

TEXDIR := ${HOME}/share/tex
CLSDIR := $(TEXDIR)/cls
STYDIR := $(TEXDIR)/sty
DOCDIR := $(TEXDIR)/docs
AUCCLSDIR := $(CLSDIR)/.style
AUCSTYDIR := $(STYDIR)/.style

W3DIR  := ${HOME}/www/comp/development

ARCHIVE        = $(PROJECT)-$(VERSION)
DISTFILES      = README NEWS $(PROJECT).ins $(PROJECT).dtx $(PROJECT).el
CTAN_DISTFILES = $(DISTFILES) $(PROJECT).pdf

all:


-include Makefile.inc


all: $(PROJECT).dvi

ifdef CLASS
all: $(PROJECT).cls
endif
ifdef STYLE
all: $(PROJECT).sty
endif

install: install-doc install-auc
ifdef CLASS
install: install-cls
endif
ifdef STYLE
install: install-sty
endif

install-cls: $(PROJECT).cls
	install -m 644 $< $(CLSDIR)
install-sty: $(PROJECT).sty
	install -m 644 $< $(STYDIR)

install-doc: $(PROJECT).dvi
	install -m 644 $< $(DOCDIR)

install-auc:
ifdef CLASS
install-auc: install-auc-cls
endif
ifdef CLASS
install-auc: install-auc-sty
endif
install-auc-cls: $(PROJECT).el
	install -m 644 $< $(AUCCLSDIR)
install-auc-sty: $(PROJECT).el
	install -m 644 $< $(AUCSTYDIR)

clean:
	-rm *~ *.aux *.lo* *.gl* *.idx *.ind *.ilg
	-rm -fr $(PROJECT)-*

distclean: clean
	-rm $(PROJECT).cls $(PROJECT).sty \
            $(PROJECT).dvi $(PROJECT).pdf $(PROJECT).ps
	-rm -fr .auto

dist:
	-rm -fr $(ARCHIVE)*
	mkdir $(ARCHIVE)
	install -m 644 $(DISTFILES) $(ARCHIVE)
	tar cvf $(ARCHIVE).tar $(ARCHIVE)
	gzip -c $(ARCHIVE).tar > $(ARCHIVE).tar.gz
	bzip2 -c $(ARCHIVE).tar > $(ARCHIVE).tar.bz2
	rm -fr $(ARCHIVE) $(ARCHIVE).tar

ctan-dist: $(PROJECT).pdf
	-rm -fr $(ARCHIVE)*
	mkdir $(ARCHIVE)
	install -m 644 $(CTAN_DISTFILES) $(ARCHIVE)
	tar cvf $(ARCHIVE).tar $(ARCHIVE)
	gzip -c $(ARCHIVE).tar > $(ARCHIVE).tar.gz
	bzip2 -c $(ARCHIVE).tar > $(ARCHIVE).tar.bz2
	rm -fr $(ARCHIVE) $(ARCHIVE).tar

install-www: dist $(PROJECT).dvi $(PROJECT).pdf
	install -m 644 NEWS $(W3DIR)/$(PROJECT)-news.txt
	echo "$(VERSION)" > $(W3DIR)/$(PROJECT)-version.txt
	chmod 644 $(W3DIR)/$(PROJECT)-version.txt
	install -m 644 $(PROJECT).dvi $(PROJECT).pdf $(W3DIR)/
	install -m 644 $(ARCHIVE).tar.gz $(W3DIR)/$(PROJECT).tar.gz
	install -m 644 $(ARCHIVE).tar.bz2 $(W3DIR)/$(PROJECT).tar.bz2

checkin:
	prcs checkin
	prcs rekey


$(PROJECT).cls $(PROJECT).sty: $(PROJECT).ins $(PROJECT).dtx
$(PROJECT).dvi: $(PROJECT).dtx

%.pdf: %.dvi
	dvipdf $<

%.cls %.sty: %.ins
	@echo "Building $@ ..."
	echo y | latex $<

%.dvi: %.dtx
	@echo "Building $@ ..."
	latex $<
#	makeindex -s gglo -o $(PROJECT).gls $(PROJECT).glo
#	makeindex -s gind $(PROJECT).idx
#	latex $<

.PHONY: all                             		        \
        install install-cls install-sty install-doc install-auc	\
        clean distclean                             		\
        dist ctan-dist                              		\
	install-www                                 		\
        checkin

### Makefile ends here
