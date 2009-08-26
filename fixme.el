;;; fixme.el --- AUC-TeX style file for FiXme

;; Copyright (C) 2000, 2002, 2004, 2006, 2009 Didier Verna.

;; Author:        Didier Verna <didier@lrde.epita.fr>
;; Maintainer:    Didier Verna <didier@lrde.epita.fr>
;; Created:       Tue Apr 18 14:49:29 2000
;; Last Revision: Wed Aug 26 13:30:10 2009
;; Keywords:      tex abbrev data


;; This file is part of FiXme.

;; FiXme may be distributed and/or modified under the
;; conditions of the LaTeX Project Public License, either version 1.1
;; of this license or (at your option) any later version.
;; The latest version of this license is in
;; http://www.latex-project.org/lppl.txt
;; and version 1.1 or later is part of all distributions of LaTeX
;; version 1999/06/01 or later.

;; FiXme consists of all files listed in the file `README'.


;;; Commentary:

;; Contents management by FCM version 0.1.



;;; Code:

(TeX-add-style-hook "fixme"
  (function
   (lambda ()
     (TeX-add-symbols
      ;; Commands		Deprecated / Obsolete / Legacy versions
      '("fixmelogo")

      '("listoffixmes")
      '("listfixmename")

      '("FXLayoutInline")	'("FXInline")		'("FiXmeInline")
      '("FXLayoutMargin")	'("FXMargin")		'("FiXmeMargin")
      '("FXLayoutMarginClue")	'("FXMarginClue")
      '("FXLayoutFootnote")	'("FXFootnote")		'("FiXmeFootnote")
      '("FXLayoutUser")		'("FXUser")		'("FiXmeUser")
      '("fixmeindexname")
      '("FXLayoutIndex")	'("FXIndex")		'("FiXmeIndex")

      '("FXLogNote")		'("FXNote")		'("FiXmeInfo")
      '("FXLogWarning")		'("FXWarning")		'("FiXmeWarning")
      '("FXLogError")		'("FXError")
      '("FXLogFatal")		'("FXFatal")

      '("fxnoteprefix")		'("fixmenoteprefix")
      '("fxnoteindexname")	'("fixmenoteindexname")
      '("fxwarningprefix")	'("fixmewarningprefix")
      '("fxwarningindexname")	'("fixmewarningindexname")
      '("fxerrorprefix")	'("fixmeerrorprefix")
      '("fxerrorindexname")	'("fixmeerrorindexname")
      '("fxfatalprefix")	'("fixmefatalprefix")
      '("fxfatalindexname")	'("fixmefatalindexname")

      '("thefixmecount")
      '("thefxnotecount")	'("thefixmenotecount")
      '("thefxwarningcount")	'("thefixmewarningcount")
      '("thefxerrorcount")	'("thefixmeerrorcount")
      '("thefxfatalcount")	'("thefixmefatalcount")

      '("fxnote" [ "Layout" ] "Note")
      '("fxwarning" [ "Layout" ] "Warning")
      '("fxerror" [ "Layout" ] "Error")
      '("fxfatal" [ "Layout" ] "Fatal")	'("fixme" [ "Layout" ] "FiXme"))

     (LaTeX-add-environments
      ;; Environments		Deprecated / Obsolete / Legacy versions
      '("anfxnote")
      '("anfxwarning")
      '("anfxerror")
      '("anfxfatal")		'("afixme")))))




;;; Local variables:
;;; eval: (put 'TeX-add-style-hook 'lisp-indent-function 1)
;;; End:

;;; fixme.el ends here
