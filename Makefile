### Makefile --- Makefile for FiXme

## Copyright (C) 1999-2002 Didier Verna.

## PRCS: $Id: Makefile 1.18 Wed, 03 Jul 2002 16:20:30 +0200 didier $

## Author:        Didier Verna <didier@lrde.epita.fr>
## Maintainer:    Didier Verna <didier@lrde.epita.fr>
## Created:       Thu Sep 23 17:27:00 1999
## Last Revision: Mon Feb 18 14:46:28 2002

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
VERSION := 2.2

ARCHIVE := $(PROJECT)-$(VERSION)
DISTFILES := README NEWS $(PROJECT).ins $(PROJECT).dtx $(PROJECT).el

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
	tar cvf $(ARCHIVE).tar $(ARCHIVE)
	gzip -c $(ARCHIVE).tar > $(ARCHIVE).tar.gz
	bzip2 -c $(ARCHIVE).tar > $(ARCHIVE).tar.bz2
	rm -fr $(ARCHIVE) $(ARCHIVE).tar

install-www: dist
	install -m 644 NEWS $(W3DIR)/fixme-news.txt
	echo "$(VERSION)" > $(W3DIR)/fixme-version.txt
	chmod 644 $(W3DIR)/fixme-version.txt
	install -m 644 $(ARCHIVE).tar.gz $(W3DIR)/$(PROJECT).tar.gz
	install -m 644 $(ARCHIVE).tar.bz2 $(W3DIR)/$(PROJECT).tar.bz2

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
