### Makefile --- Personnal Makefile for FiXme

## Copyright (C) 1999 Didier Verna.

## PRCS: $Id: Makefile 1.9 Fri, 24 Sep 1999 16:28:07 +0200 verna $

## Author:        Didier Verna <verna@inf.enst.fr>
## Maintainer:    Didier Verna <verna@inf.enst.fr>
## Created:       Tue Jan  5 16:46:40 1999 under XEmacs 21.2 (beta 8)
## Last Revision: Fri Sep 24 16:10:25 1999

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

# $Format: "VERSION=$ProjetVersion$"$
VERSION=$ProjetVersion$
ARCHIVE=xxx
DISTFILES=README fixme.ins fixme.dtx

STYDIR=${HOME}/TeX/sty
DOCDIR=${HOME}/TeX/doc

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
	gtar zcf $(ARCHIVE).tar.gz $(ARCHIVE)
	rm -fr fixme-*

checkin:
	prcs checkin
	prcs rekey

fixme.sty: fixme.ins fixme.dtx
fixme.dvi: fixme.dtx

.ins.sty:
	@echo "\n ===== Building the sty file ..."
	latex $<

.dtx.dvi:
	@echo "\n ===== Building the doc file ..."
	latex $<

.SUFFIXES: .ins .dtx .dvi .sty

### Makefile ends here
