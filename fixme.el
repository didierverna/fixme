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


;; ===========================================================================
;; Utilities
;; ===========================================================================

(defun LaTeX-fixme-xkeyval-boolean-values (items)
  "Create a list of XKeyVal boolean values for ITEMS.
Every item leads to two strings: \"item\" and \"noitem\"."
  (mapcan (lambda (item)
	    `(,item ,(concat "no" item)))
	  items))

(defun LaTeX-fixme-xkeyval-boolean-option (item)
  "Create an XKeyVal boolean option for ITEM.
This creates a list of the form (\"ITEM\" (\"true\" \"false\"))."
  `(,item ("true" "false")))

(defun LaTeX-fixme-xkeyval-boolean-options (items)
  "Create a list of XKeyVal boolean options for ITEMS.
Every item leads to two lists: (\"item\" (\"true\" \"false\"))
and (\"noitem\" (\"true\" \"false\"))."
  (mapcar #'LaTeX-fixme-xkeyval-boolean-option
	  (LaTeX-fixme-xkeyval-boolean-values items)))

;; The two functions below steal AUC-TeX's mechanism for reading key=value
;; lists of options, only without the =value part. This is probably suboptimal
;; because that part could still be entered manually (withtout, completion
;; that is) although it's not supposed to, but it's simpler to do it this
;; way.
(defun LaTeX-fixme-read-key (optional key-list &optional prompt)
  "Prompt for keys in KEY-LIST and return them.
If OPTIONAL is non-nil, indicate in the prompt that we are
reading an optional argument.  KEY-LIST is a list of strings.
Use PROMPT as the prompt string."
  (multi-prompt-key-value
   (TeX-argument-prompt optional prompt "Keys")
   (if (symbolp key-list)
       (eval key-list)
     (mapcar #'list key-list))))

(defun LaTeX-fixme-arg-key (optional key-list &optional prompt)
  "Prompt for keys in KEY-LIST.
Insert the given value as a TeX macro argument.  If OPTIONAL is
non-nil, insert it as an optional argument.  KEY-LIST is a list
of strings.  Use PROMPT as the prompt string."
  (let ((options (LaTeX-fixme-read-key optional key-list prompt)))
    (TeX-argument-insert options optional)))

(defun LaTeX-fixme-file-feature (kind)
  "Return the KIND of feature name provided by the current file, or nil.
KIND may be one of \"layout\", \"envlout\", \"targetlayout\" or
\"theme\", in order to attempt matching the file name with
\"fxKIND<feature>.sty\"."
  (let ((file-name (buffer-file-name)))
    (when file-name
      (setq file-name (file-name-nondirectory file-name))
      (when (string-match (concat (regexp-quote (concat "fx" kind))
				  "\\(.+\\)\\.sty")
			  file-name)
	(match-string 1 file-name)))))

(defun maybe-upcase-initials (string-or-nil)
  "Upcase STRING-OR-NIL initials if it is a string, or return \"\"."
  (if string-or-nil
      (upcase-initials string-or-nil)
    ""))



;; ===========================================================================
;; Options
;; ===========================================================================

;; Status processing
;; -----------------
(defvar LaTeX-fixme-status-options
  '(("final")
    ("draft")
    ("status" ("final" "draft")))
  "FiXme document status options.")


;; Layouts
;; -------
(defvar LaTeX-fixme-builtin-layouts
  '("inline" "margin" "footnote" "index" "marginclue")
  "FiXme builtin layouts.")

(defvar LaTeX-fixme-builtin-layout-boolean-values
  (LaTeX-fixme-xkeyval-boolean-values LaTeX-fixme-builtin-layouts)
  "FiXme built-in layout boolean values.")

(defvar LaTeX-fixme-builtin-layout-boolean-options
  (LaTeX-fixme-xkeyval-boolean-options LaTeX-fixme-builtin-layouts)
  "FiXme built-in layout boolean options.")

(defvar LaTeX-fixme-external-layouts
  '("marginnote"
    "pdfnote" "pdfmargin" "pdfsignote" "pdfsigmargin"
    "pdfcnote" "pdfcmargin" "pdfcsignote" "pdfcsigmargin")
  "FiXme external layouts.")

(defvar LaTeX-fixme-external-layout-boolean-values
  (LaTeX-fixme-xkeyval-boolean-values LaTeX-fixme-external-layouts)
  "FiXme external layout boolean values.")

(defvar LaTeX-fixme-external-layout-boolean-options
  (LaTeX-fixme-xkeyval-boolean-options LaTeX-fixme-external-layouts)
  "FiXme external layout boolean options.")

(defvar LaTeX-fixme-layouts
  `(,@LaTeX-fixme-builtin-layouts ,@LaTeX-fixme-external-layouts)
  "FiXme layouts.")

(defvar LaTeX-fixme-layout-boolean-values
  `(,@LaTeX-fixme-builtin-layout-boolean-values
    ,@LaTeX-fixme-external-layout-boolean-values)
  "FiXme layout boolean values.")

(defvar LaTeX-fixme-layout-boolean-options
  `(,@LaTeX-fixme-builtin-layout-boolean-options
    ,@LaTeX-fixme-external-layout-boolean-options)
  "FiXme layout boolean options.")

;; #### FIXME: this is not totally correct. The layout, morelayout and
;; innerlayout options accept either a single value, or a comma-separated list
;; of such.
(defvar LaTeX-fixme-layout-options
  `(,@LaTeX-fixme-layout-boolean-options
    ("layout" ,LaTeX-fixme-layout-boolean-values)
    ("morelayout" ,LaTeX-fixme-layout-boolean-values)
    ("innerlayout" (,@LaTeX-fixme-layout-boolean-values
		    ("layout" ,LaTeX-fixme-layout-boolean-values)
		    ("morelayout",LaTeX-fixme-layout-boolean-values))))
  "FiXme layout options.")


;; Environment layouts
;; -------------------
(defvar LaTeX-fixme-builtin-env-layouts
  '("plain" "signature")
  "FiXme builtin environment layouts.")

(defvar LaTeX-fixme-external-env-layouts
  '("color" "colorsig")
  "FiXme external environment layouts.")

(defvar LaTeX-fixme-env-layouts
  `(,@LaTeX-fixme-builtin-env-layouts ,@LaTeX-fixme-external-env-layouts)
  "FiXme environment layouts.")

(defvar LaTeX-fixme-envlayout-option
  `("envlayout" ,LaTeX-fixme-env-layouts)
  "FiXme envlayout option.")


;; Target layouts
;; --------------
(defvar LaTeX-fixme-builtin-target-layouts
  '("plain" "changebar")
  "FiXme builtin target layouts.")

(defvar LaTeX-fixme-external-target-layouts
  '("color" "colorcb")
  "FiXme external target layouts.")

(defvar LaTeX-fixme-target-layouts
  `(,@LaTeX-fixme-builtin-target-layouts ,@LaTeX-fixme-external-target-layouts)
  "FiXme target layouts.")

(defvar LaTeX-fixme-targetlayout-option
  `("targetlayout" ,LaTeX-fixme-target-layouts)
  "FiXme targetlayout option.")


;; Target option
;; -------------
(defvar LaTeX-fixme-target-option
  '("target" ("thepage"))
  "FiXme target option.")


;; Faces
;; -----
(defun LaTeX-fixme-face-option (face)
  "Return the face option corresponding to FACE.
This is (\"FACEface\")."
  `(,(concat face "face")))

(defvar LaTeX-fixme-common-faces '("inline" "margin" "signature")
  "FiXme common faces.")

(defvar LaTeX-fixme-common-face-options
  (mapcar #'LaTeX-fixme-face-option LaTeX-fixme-common-faces)
  "FiXme common face options.")

(defvar LaTeX-fixme-env-face "env"
  "FiXme environment face.")

(defvar LaTeX-fixme-env-face-option
  (LaTeX-fixme-face-option LaTeX-fixme-env-face)
  "FiXme env face option.")

(defvar LaTeX-fixme-target-face "target"
  "FiXme environment face.")

(defvar LaTeX-fixme-target-face-option
  (LaTeX-fixme-face-option LaTeX-fixme-target-face)
  "FiXme target face option.")

(defvar LaTeX-fixme-faces
  `(,@LaTeX-fixme-common-faces ,LaTeX-fixme-env-face ,LaTeX-fixme-target-face)
  "FiXme faces.")

(defvar LaTeX-fixme-face-options
  (mapcar #'LaTeX-fixme-face-option LaTeX-fixme-faces)
  "FiXme face options.")


;; Logging
;; -------
(defvar LaTeX-fixme-logging-options
  (LaTeX-fixme-xkeyval-boolean-options '("silent"))
  "FiXme logging options.")


;; Languages
;; ---------
(defvar LaTeX-fixme-languages
  '("english" "french" "francais" "spanish" "italian" "german" "ngerman"
    "danish" "croatian")
  "FiXme Languages.")

;; #### NOTE: langtrack not included
(defvar LaTeX-fixme-language-options
  `(,@(mapcar #'list LaTeX-fixme-languages)
    ("lang" ,LaTeX-fixme-languages)
    ("defaultlang" ,LaTeX-fixme-languages))
  "FiXme options for language selection.")

(defvar LaTeX-fixme-langtrack-option
  (LaTeX-fixme-xkeyval-boolean-option "langtrack")
  "FiXme langtrack option.")


;; Authoring
;; ---------
(defvar LaTeX-fixme-author-option
  '("author")
  "FiXme author option.")


(defvar LaTeX-fixme-mode-options
  `(,(LaTeX-fixme-xkeyval-boolean-option "singleuser")
    ,(LaTeX-fixme-xkeyval-boolean-option "multiuser")
    ("mode" ("singleuser" "multiuser")))
  "FiXme mode options.")


;; Themes
;; ------
(defvar LaTeX-fixme-themes
  '("signature" "color" "colorsig")
  "FiXme themes.")

(defvar LaTeX-fixme-theme-option
  `("theme" ,LaTeX-fixme-themes)
  "FiXme theme option.")


;; Macro-dependent
;; ---------------
(defvar LaTeX-fixme-args-annotation
  `([ TeX-arg-key-val (,@LaTeX-fixme-status-options
		       ,@LaTeX-fixme-layout-options
		       ,@LaTeX-fixme-common-face-options
		       ,LaTeX-fixme-target-option
		       ,@LaTeX-fixme-logging-options
		       ,@LaTeX-fixme-language-options
		       ,LaTeX-fixme-author-option
		       ,@LaTeX-fixme-mode-options) ]
    t)
  "FiXme annotation arguments.
Options (mostly all, except for envlayout, targetlayout, envface,
targetface, langtrack and theme), and a pair of braces.")

(defvar LaTeX-fixme-args-targeted-annotation
  `([ TeX-arg-key-val (,@LaTeX-fixme-status-options
		       ,@LaTeX-fixme-layout-options
		       ,@LaTeX-fixme-common-face-options
		       ,LaTeX-fixme-targetlayout-option
		       ,LaTeX-fixme-target-option
		       ,LaTeX-fixme-target-face-option
		       ,@LaTeX-fixme-logging-options
		       ,@LaTeX-fixme-language-options
		       ,LaTeX-fixme-author-option
		       ,@LaTeX-fixme-mode-options) ]
    t
    ;; #### FIXME: is there a way to insert braces around the active region,
    ;; but not encompassing the macro (as -1 does)? That would be better, as a
    ;; targeted annotation is most of the time written when the target text
    ;; already exists.
    nil)
  "FiXme targeted annotation arguments.
Options (mostly all, except for envlayout, envface, langtrack and
theme), annotation text and a pair of braces.")

;; #### NOTE: an even DWIMer thing to do would be to make the MACRO argument
;; depend on the NAME one, in case the user changed it from the initial input.
(defvar LaTeX-fixme-args-register-layout
  `([ (LaTeX-fixme-arg-key ,LaTeX-fixme-layouts "Incompatible layout(s)") ]
    (TeX-arg-eval TeX-read-string "Name: " (LaTeX-fixme-file-feature "layout"))
    (TeX-arg-eval TeX-read-string "Macro: "
		  (concat TeX-esc "FXLayout"
			  (maybe-upcase-initials
			   (LaTeX-fixme-file-feature "layout")))))
  "FiXme layout registration arguments.
An optional mutual exclusion list, a layout name and the
corresponding macro.")


;; Environment-dependent
;; ---------------------
(defvar LaTeX-fixme-args-environment
  `(LaTeX-env-args [ (TeX-arg-key-val (,@LaTeX-fixme-status-options
				       ,@LaTeX-fixme-layout-options
				       ,@LaTeX-fixme-common-face-options
				       ,LaTeX-fixme-envlayout-option
				       ,LaTeX-fixme-env-face-option
				       ,LaTeX-fixme-target-option
				       ,@LaTeX-fixme-logging-options
				       ,@LaTeX-fixme-language-options
				       ,LaTeX-fixme-author-option
				       ,@LaTeX-fixme-mode-options)) ]
		   ;; #### FIXME: is there a way to get the point here instead
		   ;; of inside the environment's body?
		   t)
  "FiXme environment arguments.
Options (mostly all, except for targetlayout, targetface,
langtrack and theme), and a summary.")

(defvar LaTeX-fixme-args-targeted-environment
  `(LaTeX-env-args [ (TeX-arg-key-val (,@LaTeX-fixme-status-options
				       ,@LaTeX-fixme-layout-options
				       ,@LaTeX-fixme-common-face-options
				       ,LaTeX-fixme-envlayout-option
				       ,LaTeX-fixme-env-face-option
				       ,LaTeX-fixme-targetlayout-option
				       ,LaTeX-fixme-target-face-option
				       ,LaTeX-fixme-target-option
				       ,@LaTeX-fixme-logging-options
				       ,@LaTeX-fixme-language-options
				       ,LaTeX-fixme-author-option
				       ,@LaTeX-fixme-mode-options)) ]
		   ;; #### FIXME: is there a way to get the point here instead
		   ;; of inside the environment's body?
		   t
		   ;; #### FIXME: is there a way to insert braces around the
		   ;; active region, but not encompassing the macro (as -1
		   ;; does)? That would be better, as a targeted annotation is
		   ;; most of the time written when the target text already
		   ;; exists.
		   nil)
  "FiXme targeted environment arguments.
Options (mostly all, except for langtrack and theme), a summary,
and a pair of braces.")



;; ===========================================================================
;; Style Hooks
;; ===========================================================================

(TeX-add-style-hook "fixme"
  (lambda ()

    (TeX-add-symbols
     `("fxsetup" (TeX-arg-key-val (,@LaTeX-fixme-status-options
				   ,@LaTeX-fixme-layout-options
				   ,@LaTeX-fixme-common-face-options
				   ,LaTeX-fixme-envlayout-option
				   ,LaTeX-fixme-env-face-option
				   ,LaTeX-fixme-targetlayout-option
				   ,LaTeX-fixme-target-face-option
				   ,LaTeX-fixme-target-option
				   ,@LaTeX-fixme-logging-options
				   ,@LaTeX-fixme-language-options
				   ,LaTeX-fixme-langtrack-option
				   ,LaTeX-fixme-author-option
				   ,@LaTeX-fixme-mode-options
				   ,LaTeX-fixme-theme-option)))

     `("fxnote"    ,@LaTeX-fixme-args-annotation)
     `("fxwarning" ,@LaTeX-fixme-args-annotation)
     `("fxerror"   ,@LaTeX-fixme-args-annotation)
     `("fxfatal"   ,@LaTeX-fixme-args-annotation)
     ;; #### NOTE: \fixme is obsolete so I don't want to support it here.

     `("fxnote*"    ,@LaTeX-fixme-args-targeted-annotation)
     `("fxwarning*" ,@LaTeX-fixme-args-targeted-annotation)
     `("fxerror*"   ,@LaTeX-fixme-args-targeted-annotation)
     `("fxfatal*"   ,@LaTeX-fixme-args-targeted-annotation)

     '("listoffixmes" 0)

     `("fxuselayouts" (TeX-arg-key-val ,LaTeX-fixme-layout-boolean-options
				       "Layout options"))
     `("fxloadlayouts" (LaTeX-fixme-arg-key ,LaTeX-fixme-external-layouts
					    "External layouts"))

     '("fxuseenvlayout" (TeX-arg-eval completing-read "Environment layout: "
				      LaTeX-fixme-env-layouts))
     `("fxloadenvlayouts" (LaTeX-fixme-arg-key
			   ,LaTeX-fixme-external-env-layouts
			   "External environment layout(s)"))

     '("fxusetargetlayout" (TeX-arg-eval completing-read "Target layout: "
					 LaTeX-fixme-target-layouts))
     `("fxloadtargetlayouts" (LaTeX-fixme-arg-key
			      ,LaTeX-fixme-external-target-layouts
			      "External target layout(s)"))

     '("fxsetface" (TeX-arg-eval completing-read "Face: " LaTeX-fixme-faces) t)

     ;; #### FIXME: we could programmatically construct default values for the
     ;; environment prefix and the tag, based on the command one.
     '("FXRegisterAuthor" "Command prefix" "Environment prefix" "Tag")

     '("fxusetheme" (TeX-arg-eval completing-read "Theme: " LaTeX-fixme-themes))

     `("FXRegisterLayout"  ,@LaTeX-fixme-args-register-layout)
     `("FXRegisterLayout*" ,@LaTeX-fixme-args-register-layout)
     '("FXProvidesLayout"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "layout"))
       [ TeX-arg-version ])
     `("FXRequireLayouts"  (LaTeX-fixme-arg-key ,LaTeX-fixme-external-layouts
						"External layout(s)"))

     '("FXRegisterEnvLayout"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "envlayout"))
       (TeX-arg-eval TeX-read-string "Opening macro: "
		     (concat TeX-esc "FXEnvLayout"
			     (maybe-upcase-initials
			      (LaTeX-fixme-file-feature "envlayout"))
			     "Begin"))
       (TeX-arg-eval TeX-read-string "Closing macro: "
		     (concat TeX-esc "FXEnvLayout"
			     (upcase-initials
			      (maybe-LaTeX-fixme-file-feature "envlayout"))
			     "End")))
     '("FXProvidesEnvLayout"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "envlayout"))
       [ TeX-arg-version ])
     '("FXRequireEnvLayout"  (TeX-arg-eval completing-read
					   "External environment layout: "
					   LaTeX-fixme-external-env-layouts))

     '("FXRegisterTargetLayout"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "targetlayout"))
       (TeX-arg-eval TeX-read-string "Macro: "
		     (concat TeX-esc "FXTargetLayout"
			     (maybe-upcase-initials
			      (LaTeX-fixme-file-feature "targetlayout")))))
     '("FXProvidesTargetLayout"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "targetlayout"))
       [ TeX-arg-version ])
     '("Fxrequiretargetlayout"
       (TeX-arg-eval completing-read "External target layout: "
		     LaTeX-fixme-external-target-layouts))

     '("FXProvidesTheme"
       (TeX-arg-eval TeX-read-string "Name: "
		     (LaTeX-fixme-file-feature "theme"))
       [ TeX-arg-version ]))

    (apply #'TeX-add-symbols
	   (mapcan (lambda (macro)
		     (mapcar (lambda (language)
			       (list (concat "fx" language macro) 0))
			     ;; #### NOTE: francais is an alias to french.
			     (remove "francais" LaTeX-fixme-languages)))
		   (mapcar (lambda (macro) (concat macro "name"))
			   '("note" "notes"
			     "warning" "warnings"
			     "error" "errors"
			     "fatal" "fatals"))))

    (apply #'TeX-add-symbols
	   (mapcar (lambda (language)
		     (list (concat language "listfixmename") 0))
		   ;; #### NOTE: francais is an alias to french.
		   (remove "francais" LaTeX-fixme-languages)))


    (LaTeX-add-environments
     `("anfxnote"    ,@LaTeX-fixme-args-environment)
     `("anfxwarning" ,@LaTeX-fixme-args-environment)
     `("anfxerror"   ,@LaTeX-fixme-args-environment)
     `("anfxfatal"   ,@LaTeX-fixme-args-environment)

     `("anfxnote*"    ,@LaTeX-fixme-args-targeted-environment)
     `("anfxwarning*" ,@LaTeX-fixme-args-targeted-environment)
     `("anfxerror*"   ,@LaTeX-fixme-args-targeted-environment)
     `("anfxfatal*"   ,@LaTeX-fixme-args-targeted-environment))


    (when (and (featurep 'font-latex)
	       (eq TeX-install-font-lock 'font-latex-setup))
      (font-latex-add-keywords '(("fxsetup" "{")

				 "listoffixmes"

				 ("fxuselayouts"  "{")
				 ("fxloadlayouts" "{")

				 ("fxuseenvlayout"   "{")
				 ("fxloadenvlayouts" "{")

				 ("fxusetargetlayout"   "{")
				 ("fxloadtargetlayouts" "{")

				 ("fxsetface" "{{")

				 ("FXRegisterAuthor" "{{{")

				 ("fxusetheme" "{")

				 ("FXRegisterLayout" "*[{{")
				 ("FXProvidesLayout" "{[")
				 ("FXRequireLayout"  "{")

				 ("FXRegisterEnvLayout" "{{{")
				 ("FXProvidesEnvLayout" "{[")
				 ("FXRequireEnvLayout"  "{")

				 ("FXRegisterTargetLayout" "{{")
				 ("FXProvidesTargetLayout" "{[")
				 ("FXRequireTargetLayout"  "{")

				 ("FXProvidesTheme" "{["))
			       'function)
      ;; The starred version of the 4 macros below takes a second mandatory
      ;; argument. We skip this since it would confuse font-latex when used as
      ;; the non-starred version
      (font-latex-add-keywords '(("fxnote"    "*[{")
				 ("fxwarning" "*[{")
				 ("fxerror"   "*[{")
				 ("fxfatal"   "*[{"))
			       'textual)))
  LaTeX-dialect)



;;; Local variables:
;;; eval: (put 'TeX-add-style-hook 'lisp-indent-function 1)
;;; End:

;;; fixme.el ends here
