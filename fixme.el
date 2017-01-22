;;; fixme.el --- AUC-TeX style file for FiXme

;; Copyright (C) 2000, 2002, 2004, 2006, 2009, 2017 Didier Verna

;; Author: Didier Verna <didier@didierverna.net>
;; Keywords: tex abbrev data

;; This file is part of FiXme.

;; FiXme may be distributed and/or modified under the conditions of the LaTeX
;; Project Public License, either version 1.3 of this license or (at your
;; option) any later version. The latest version of this license is in
;; http://www.latex-project.org/lppl.txt and version 1.3 or later is part of
;; all distributions of LaTeX version 2005/12/01 or later.

;; FiXme consists of all files listed in the file `README.md'.


;;; Commentary:


;;; Code:

(TeX-add-style-hook "fixme"
  (function
   (lambda ()
     (TeX-add-symbols
      '("fxsetup")

      '("fxnote"    ["Options"] "Annotation")
      '("fxwarning" ["Options"] "Annotation")
      '("fxerror"   ["Options"] "Annotation")
      '("fxfatal"   ["Options"] "Annotation")
      '("fixme"     ["Options"] "Annotation")

      '("fxnote*"    ["Options"] "Annotation" t)
      '("fxwarning*" ["Options"] "Annotation" t)
      '("fxerror*"   ["Options"] "Annotation" t)
      '("fxfatal*"   ["Options"] "Annotation" t)

      '("listoffixmes" 0)

      '("fxuselayouts"  t)
      '("fxloadlayouts" t)
      '("fxuseenvlayout"   t)
      '("fxloadenvlayouts" t)
      '("fxusetargetlayout"   t)
      '("fxloadtargetlayouts" t)

      '("fxsetface" "Face" "Value")

      '("FXRegisterAuthor" "Command prefix" "Environment prefix" "Tag")

      '("fxusetheme" "Theme")

      '("FXRegisterLayout"       "Name" "Macro")
      '("FXRegisterLayout*"      "Name" "Macro")
      '("FXRegisterEnvLayout"    "Name" "Opening macro" "Closing macro")
      '("FXRegisterTargetLayout" "Name" "Macro")

      '("FXRequireLayout"       "Name")
      '("FXRequireEnvLayout"    "Name")
      '("FXRequireTargetLayout" "Name")

      '("FXProvidesLayout"       "Name" ["Release information"])
      '("FXProvidesEnvLayout"    "Name" ["Release information"])
      '("FXProvidesTargetLayout" "Name" ["Release information"])

      '("fxenglishnotename" 0)
      '("fxenglishnotesname" 0)
      '("fxenglishwarningname" 0)
      '("fxenglishwarningsname" 0)
      '("fxenglisherrorname" 0)
      '("fxenglisherrorsname" 0)
      '("fxenglishfatalname" 0)
      '("fxenglishfatalsname" 0)
      '("fxfrenchnotename" 0)
      '("fxfrenchnotesname" 0)
      '("fxfrenchwarningname" 0)
      '("fxfrenchwarningsname" 0)
      '("fxfrencherrorname" 0)
      '("fxfrencherrorsname" 0)
      '("fxfrenchfatalname" 0)
      '("fxfrenchfatalsname" 0)
      '("fxspanishnotename" 0)
      '("fxspanishnotesname" 0)
      '("fxspanishwarningname" 0)
      '("fxspanishwarningsname" 0)
      '("fxspanisherrorname" 0)
      '("fxspanisherrorsname" 0)
      '("fxspanishfatalname" 0)
      '("fxspanishfatalsname" 0)
      '("fxitaliannotename" 0)
      '("fxitaliannotesname" 0)
      '("fxitalianwarningname" 0)
      '("fxitalianwarningsname" 0)
      '("fxitalianerrorname" 0)
      '("fxitalianerrorsname" 0)
      '("fxitalianfatalname" 0)
      '("fxitalianfatalsname" 0)
      '("fxgermannotename" 0)
      '("fxgermannotesname" 0)
      '("fxgermanwarningname" 0)
      '("fxgermanwarningsname" 0)
      '("fxgermanerrorname" 0)
      '("fxgermanerrorsname" 0)
      '("fxgermanfatalname" 0)
      '("fxgermanfatalsname" 0)
      '("fxdanishnotename" 0)
      '("fxdanishnotesname" 0)
      '("fxdanishwarningname" 0)
      '("fxdanishwarningsname" 0)
      '("fxdanisherrorname" 0)
      '("fxdanisherrorsname" 0)
      '("fxdanishfatalname" 0)
      '("fxdanishfatalsname" 0)
      '("fxcroatiannotename" 0)
      '("fxcroatiannotesname" 0)
      '("fxcroatianwarningname" 0)
      '("fxcroatianwarningsname" 0)
      '("fxcroatianerrorname" 0)
      '("fxcroatianerrorsname" 0)
      '("fxcroatianfatalname" 0)
      '("fxcroatianfatalsname" 0)

      '("englishlistfixmename" 0)
      '("frenchlistfixmename" 0)
      '("spanishlistfixmename" 0)
      '("italianlistfixmename" 0)
      '("germanlistfixmename" 0)
      '("danishlistfixmename" 0)
      '("croatianlistfixmename" 0))

     (LaTeX-add-environments
      '("anfxnote"    ["Options"] "Summary")
      '("anfxwarning" ["Options"] "Summary")
      '("anfxerror"   ["Options"] "Summary")
      '("anfxfatal"   ["Options"] "Summary")
      '("afixme"      ["Options"] "Summary")

      ;; #### NOTE: I would like to insert a couple of braces here.
      '("anfxnote*"    ["Options"] "Summary")
      '("anfxwarning*" ["Options"] "Summary")
      '("anfxerror*"   ["Options"] "Summary")
      '("anfxfatal*"   ["Options"] "Summary")))))



;;; Local variables:
;;; eval: (put 'TeX-add-style-hook 'lisp-indent-function 1)
;;; End:

;;; fixme.el ends here
