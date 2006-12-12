### Makefile --- Personnal Makefile for FiXme

## Copyright (C) 1999-2000 Didier Verna.

## PRCS: $Id: Makefile 1.10 Wed, 29 Mar 2000 11:09:02 +0200 didier $

## Author:        Didier Verna <didier@epita.fr>
## Maintainer:    Didier Verna <didier@epita.fr>
## Created:       Tue Jan  5 16:46:40 1999
## Last Revision: Wed Mar 29 10:18:02 2000

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

STYDIR=${HOME}/share/tex/sty
DOCDIR=${HOME}/share/tex/doc

## $Format: "VERSION := $PackageVersion$"$
VERSION := 1.1-b19
ARCHIVE := fixme-$(VERSION)
DISTFILES := README fixme.ins fixme.dtx

all: fixme.sty fixme.dvi

install: install-sty install-doc
install-sty: fixme.sty
	cp fixme.sty $(STYDIR)
install-doc: fixme.dvi
	cp fixme.dvi $(DOCDIR)

clean:
	-rm *~ *.aux *.lo*
distclean: clean
	-rm fixme.sty fixme.dvi

dist:
	-rm -fr fixme-*
	mkdir $(ARCHIVE)
	cp $(DISTFILES) $(ARCHIVE)
	tar zcvf $(ARCHIVE).tar.gz $(ARCHIVE)
	rm -fr fixme-*

checkin:
	prcs checkin
	prcs rekey

fixme.sty: fixme.ins fixme.dtx
fixme.dvi: fixme.dtx

%.sty: %.ins
	@echo "\n ===== Building the sty file ..."
	latex $<

%.dvi: %.dtx
	@echo "\n ===== Building the doc file ..."
	latex $<

.PHONY: all install install-sty install-doc clean distclean dist checkin

### Makefile ends here
