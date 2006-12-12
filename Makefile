### Makefile --- Makefile for FiXme

## Copyright (C) 1999-2000 Didier Verna.

## PRCS: $Id: Makefile 1.15 Mon, 23 Apr 2001 12:07:55 +0200 didier $

## Author:        Didier Verna <didier@lrde.epita.fr>
## Maintainer:    Didier Verna <didier@lrde.epita.fr>
## Created:       Thu Sep 23 17:27:00 1999
## Last Revision: Tue Mar 28 18:49:43 2000

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
DOCDIR := $(TEXDIR)/doc

W3DIR  := ${HOME}/www/comp/development

## $Format: "VERSION := $Version$"$
VERSION := 1.3

ARCHIVE := $(PROJECT)-$(VERSION)
DISTFILES := README $(PROJECT).ins $(PROJECT).dtx $(PROJECT).el

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
	-rm $(PROJECT).sty $(PROJECT).dvi

dist:
	-rm -fr $(ARCHIVE)*
	mkdir $(ARCHIVE)
	cp $(DISTFILES) $(ARCHIVE)
	tar zcvf $(ARCHIVE).tar.gz $(ARCHIVE)
	rm -fr $(ARCHIVE)

install-www: dist
	install -m 644 $(ARCHIVE).tar.gz $(W3DIR)/$(PROJECT).tar.gz

checkin:
	prcs checkin
	prcs rekey


$(PROJECT).sty: $(PROJECT).ins $(PROJECT).dtx
$(PROJECT).dvi: $(PROJECT).dtx

%.sty: %.ins
	@echo "Building the sty file ..."
	echo y | latex $<

%.dvi: %.dtx
	@echo "Building the dvi file ..."
	latex $<
#	makeindex -s gglo -o fink.gls fink.glo
#	makeindex -s gind fink.idx
#	latex $<

.PHONY: all                                         \
        install install-sty install-doc install-auc \
        clean distclean                             \
        dist                                        \
        checkin

### Makefile ends here
