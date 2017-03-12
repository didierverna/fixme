ABOUT FIXME
===========

Copyright (C) 1998-2002, 2004-2007, 2009, 2013, 2017 Didier Verna

Author: Didier Verna <didier@didierverna.net>

This file is part of FiXme.

FiXme may be distributed and/or modified under the conditions of the LaTeX
Project Public License, either version 1.3 of this license or (at your option)
any later version. The latest version of this license is in
http://www.latex-project.org/lppl.txt and version 1.3 or later is part of all
distributions of LaTeX version 2005/12/01 or later.

FiXme consists of the following files:

- README.md (this file)
- NEWS
- fixme.ins
- fixme.dtx
- fixme.el
- THANKS


Description
-----------
FiXme is a collaborative annotation tool for LaTeX documents. Annotating a
document refers here to inserting meta-notes, that is, notes that do not
belong to the document itself, but rather to its development or reviewing
process. Such notes may involve things of different importance levels, ranging
from simple "fix the spelling" flags to critical "this paragraph is a lie"
mentions. Annotations like this should be visible during the development or
reviewing phase, but should normally disappear in the final version of the
document.

FiXme is designed to ease and automate the process of managing collaborative
annotations, by offering a set of predefined note levels and layouts, the
possibility to register multiple authors, to reference annotations by listing
and indexing etc. FiXme is extensible, giving you the possibility to create
new layouts or even complete "themes", and also comes with support
for [AUCTeX](https://www.gnu.org/software/auctex/).

FiXme homepage: http://www.lrde.epita.fr/~didier/software/latex.php#fixme


Installation
------------
If you are building FiXme from the tarball you need to execute the following
steps in order to extract the necessary files. FiXme also requires
the [DoX](https://www.lrde.epita.fr/~didier/software/latex.php#dox) package
(version 2.0, release date 2009/09/21 or later), to build. It is not required
to use the package.

	[pdf]latex fixme.ins
	[pdf]latex fixme.dtx
	[pdf]latex fixme.dtx
	makeindex -s gind fixme.idx
	[pdf]latex fixme.dtx
	[pdf]latex fixme.dtx

After that, you need to install the generated documentation and style files to
a location where LaTeX can find them. For a TDS-compliant layout, the
following locations are suggested:

	[TEXMF]/tex/latex/fixme/fixme.sty
	[TEXMF]/tex/latex/fixme/layouts/fxlayout*.sty
	[TEXMF]/tex/latex/fixme/layouts/env/fxenvlayout*.sty
	[TEXMF]/tex/latex/fixme/layouts/target/fxtargetlayout*.sty
	[TEXMF]/tex/latex/fixme/themes/fxtheme*.sty
	[TEXMF]/doc/latex/fixme/fixme.[pdf|dvi]

If you're an AUCTeX user, you may also install the file `fixme.el` in a
suitable AUCTeX style directory.
