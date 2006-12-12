### Makefile --- Makefile for FiXme

## Copyright (C) 1999, 2000, 2001, 2002, 2004 Didier Verna.

## PRCS: $Id: Makefile 1.22 Tue, 19 Oct 2004 17:22:50 +0200 didier $

## Author:        Didier Verna <didier@lrde.epita.fr>
## Maintainer:    Didier Verna <didier@lrde.epita.fr>
## Created:       Thu Sep 23 17:27:00 1999
## Last Revision: Tue Oct 19 11:07:32 2004

## This file is part of FiXme.

## FiXme may be distributed and/or modified under the
## conditions of the LaTeX Project Public License, either version 1.1
## of this license or (at your option) any later version.
## The latest version of this license is in
## http://www.latex-project.org/lppl.txt
## and version 1.1 or later is part of all distributions of LaTeX
## version 1999/06/01 or later.

## FiXme consists of the files listed in the file `README'.


### Commentary:

## Contents management by FCM version 0.1.


### Code:

## $Format: "PROJECT := $Project$"$
PROJECT := fixme

TEXDIR := ${HOME}/share/tex
STYDIR := $(TEXDIR)/sty
AUCDIR := $(STYDIR)/.style
DOCDIR := $(TEXDIR)/docs

W3DIR  := ${HOME}/www/comp/development

## $Format: "VERSION := $Version$"$
VERSION := 2.3

ARCHIVE        := $(PROJECT)-$(VERSION)
DISTFILES      := README NEWS $(PROJECT).ins $(PROJECT).dtx $(PROJECT).el
CTAN_DISTFILES := $(DISTFILES) $(PROJECT).pdf

all: $(PROJECT).sty $(PROJECT).dvi

install: install-sty install-doc install-auc
install-sty: $(PROJECT).sty
	cp $< $(STYDIR)
install-doc: $(PROJECT).dvi
	cp $< $(DOCDIR)
install-auc: $(PROJECT).el
	cp $< $(AUCDIR)

clean:
	-rm *~ *.aux *.lo* *.gl* *.idx *.ind *.ilg
	-rm -fr $(PROJECT)-*

distclean: clean
	-rm $(PROJECT).sty $(PROJECT).dvi $(PROJECT).pdf $(PROJECT).ps
	-rm -fr .auto

dist:
	-rm -fr $(ARCHIVE)*
	mkdir $(ARCHIVE)
	cp $(DISTFILES) $(ARCHIVE)
	tar cvf $(ARCHIVE).tar $(ARCHIVE)
	gzip -c $(ARCHIVE).tar > $(ARCHIVE).tar.gz
	bzip2 -c $(ARCHIVE).tar > $(ARCHIVE).tar.bz2
	rm -fr $(ARCHIVE) $(ARCHIVE).tar

ctan-dist: $(PROJECT).pdf
	-rm -fr $(ARCHIVE)*
	mkdir $(ARCHIVE)
	cp $(CTAN_DISTFILES) $(ARCHIVE)
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


$(PROJECT).sty: $(PROJECT).ins $(PROJECT).dtx
$(PROJECT).dvi: $(PROJECT).dtx

%.pdf: %.dvi
	dvipdf $<

%.sty: %.ins
	@echo "Building the sty file ..."
	echo y | latex $<

%.dvi: %.dtx
	@echo "Building the dvi file ..."
	latex $< ; latex $<
#	makeindex -s gglo -o $(PROJECT).gls $(PROJECT).glo
#	makeindex -s gind $(PROJECT).idx
#	latex $<

.PHONY: all                                         \
        install install-sty install-doc install-auc \
        clean distclean                             \
        dist ctan-dist                              \
	install-www                                 \
        checkin

### Makefile ends here
