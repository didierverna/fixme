;;; fixme.el --- AUC-TeX style file for FiXme

;; Copyright (C) 2000, 2002, 2004, 2006 Didier Verna.

;; Author:        Didier Verna <didier@lrde.epita.fr>
;; Maintainer:    Didier Verna <didier@lrde.epita.fr>
;; Created:       Tue Apr 18 14:49:29 2000
;; Last Revision: Tue Oct 19 18:07:27 2004
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

;; Contents management by FCM version 0.1-b2.


;;; Code:

(TeX-add-style-hook "fixme"
  (function
   (lambda ()
     (TeX-add-symbols
      '("fixmelogo")

      '("listoffixmes")
      '("listfixmename")

      '("FXInline")
      '("FXMargin")
      '("FXMarginClue")
      '("FXFootnote")
      '("FXUser")
      '("fixmeindexname")
      '("FXIndex")

      '("FXNote")
      '("FXWarning")
      '("FXError")
      '("FXFatal")

      '("fixmenoteprefix")
      '("fixmenoteindexname")
      '("fixmewarningprefix")
      '("fixmewarningindexname")
      '("fixmeerrorprefix")
      '("fixmeerrorindexname")
      '("fixmefatalprefix")
      '("fixmefatalindexname")

      '("thefixmecount")
      '("thefixmenotecount")
      '("thefixmewarningcount")
      '("thefixmeerrorcount")
      '("thefixmefatalcount")

      '("fxnote" [ "Layout" ] "Note")
      '("fxwarning" [ "Layout" ] "Warning")
      '("fxerror" [ "Layout" ] "Error")
      '("fixme" [ "Layout" ] "FiXme")

      ;; Obsolete stuff:
      '("FiXmeInline")
      '("FiXmeMargin")
      '("FiXmeFootnote")
      '("FiXmeIndex")
      '("FiXmeInfo")
      '("FiXmeWarning")
      '("FiXmeUser")
      )
     (LaTeX-add-environments
      '("anfxnote")
      '("anfxwarning")
      '("anfxerror")
      '("afixme")
      )
     )))




;;; Local variables:
;;; eval: (put 'TeX-add-style-hook 'lisp-indent-function 1)
;;; End:

;;; fixme.el ends here
