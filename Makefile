### Makefile --- Personnal Makefile for common FiXme targets

## Copyright (C) 1999 Didier Verna.

## PRCS: $Id: Makefile 1.4 Wed, 06 Jan 1999 15:00:36 +0100 verna $

## Author:        Didier Verna <verna@inf.enst.fr>
## Maintainer:    Didier Verna <verna@inf.enst.fr>
## Created:       Tue Jan  5 16:46:40 1999 under XEmacs 21.2 (beta 8)
## Last Revision: Wed Jan  6 14:36:22 1999

## This file is part of FiXme.

## FiXme is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## You are NOT ALLOWED to distribute this file alone. However,
## you are allowed to distribute this file under the condition
## that it is distributed along with the whole FiXme package.
## If you receive only some of these files from someone, complain!

## You are NOT ALLOWED to modify this file, or any other file in the
## FiXme package, other than for personal use or within an organization.
## However, you are allowed to freely incorporate (possibly modified)
## parts of this file in other files with clearly different names,
## provided that the original authors are given full credit for their work.

## You are NOT ALLOWED to charge a fee for distribution or use of this
## package or any derivative work as described above, other than for the
## physical act of transferring copies. 


### Commentary:

## Contents management by FCM version 0.1.


### TODO:


### Change Log:


### Code:

DISTFILES=README fixme.ins fixme.dtx

STYDIR=${HOME}/TeX/styles
DOCDIR=${HOME}/TeX/doc

all: fixme.sty fixme.dvi

dist:
	-rm -fr fixme
	mkdir fixme
	cp $(DISTFILES) fixme
	gtar zcf fixme.tar.gz fixme
	rm -fr fixme

test: test.dvi

install: install-doc install-sty

install-doc: fixme.dvi
	cp fixme.dvi $(DOCDIR)
install-sty: fixme.sty
	cp fixme.sty $(STYDIR)

distclean: clean clean-doc clean-sty

clean:
	-rm *~ *.aux *.log

clean-doc:
	-rm *.dvi
clean-sty:
	-rm *.sty

fixme.sty: fixme.ins fixme.dtx
fixme.dvi: fixme.dtx
test.dvi: test.ltx fixme.sty

.ins.sty:
	@echo "\n ===== Building the sty file ..."
	latex $<

.dtx.dvi:
	@echo "\n ===== Building the doc file ..."
	latex $<

.ltx.dvi:
	@echo "\n ===== Building the test file ..."
	latex $<

.SUFFIXES: .dvi .sty .dtx .ins .ltx

### Makefile ends here
