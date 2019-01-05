;;; fixme.el --- AUCTeX style file for FiXme

;; Copyright (C) 2000, 2002, 2004, 2006, 2009, 2017, 2019 Didier Verna

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
  "Create a sorted list of XKeyVal boolean values for ITEMS.
Every item leads to two strings: \"item\" and \"noitem\"."
  (sort (mapcan (lambda (item) `(,item ,(concat "no" item))) items)
	#'string<))

(defun LaTeX-fixme-xkeyval-boolean-option (item)
  "Create an XKeyVal boolean option for ITEM.
This creates a list of the form (\"ITEM\" (\"true\" \"false\"))."
  `(,item ("true" "false")))

(defun LaTeX-fixme-option< (option1 option2)
  "Return t if the car of OPTION1 is STRING< to the car of OPTION2.
This function is used as a predicate for sorting XKeyVal option
lists."
  (string< (car option1) (car option2)))

(defun LaTeX-fixme-xkeyval-boolean-options (items)
  "Create a sorted list of XKeyVal boolean options for ITEMS.
Every item leads to two lists: (\"item\" (\"true\" \"false\"))
and (\"noitem\" (\"true\" \"false\"))."
  (sort (mapcar #'LaTeX-fixme-xkeyval-boolean-option
		(LaTeX-fixme-xkeyval-boolean-values items))
	#'LaTeX-fixme-option<))

;; The two functions below steal AUCTeX's mechanism for reading key=value
;; lists of options, only without the =value part. This is probably suboptimal
;; because that part could still be entered manually (withtout, completion
;; that is) although it's not supposed to, but it's simpler to do it this way.
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
  "Prompt for keys in KEY-LIST and insert them as a TeX macro argument.
If OPTIONAL is non-nil, insert as an optional argument.  KEY-LIST
is a list of strings.  Use PROMPT as the prompt string."
  (TeX-argument-insert (LaTeX-fixme-read-key optional key-list prompt)
		       optional))

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
  (if string-or-nil (upcase-initials string-or-nil) ""))



;; ===========================================================================
;; Options
;; ===========================================================================

;; Status processing
;; -----------------
(defvar LaTeX-fixme-status-options
  '(("draft")
    ("final")
    ("status" ("draft" "final")))
  "FiXme document status options.")


;; Layouts
;; -------
(defvar LaTeX-fixme-builtin-layouts
  '("footnote" "index" "inline" "margin" "marginclue")
  "FiXme builtin layouts.")

(defvar LaTeX-fixme-builtin-layout-boolean-values
  (LaTeX-fixme-xkeyval-boolean-values LaTeX-fixme-builtin-layouts)
  "FiXme built-in layout boolean values.")

(defvar LaTeX-fixme-builtin-layout-boolean-options
  (LaTeX-fixme-xkeyval-boolean-options LaTeX-fixme-builtin-layouts)
  "FiXme built-in layout boolean options.")

(defvar LaTeX-fixme-external-layouts
  '("marginnote"
    "pdfcmargin" "pdfcnote" "pdfcsigmargin" "pdfcsignote"
    "pdfmargin" "pdfnote" "pdfsigmargin" "pdfsignote")
  "FiXme external layouts.")

(defvar LaTeX-fixme-external-layout-boolean-values
  (LaTeX-fixme-xkeyval-boolean-values LaTeX-fixme-external-layouts)
  "FiXme external layout boolean values.")

(defvar LaTeX-fixme-external-layout-boolean-options
  (LaTeX-fixme-xkeyval-boolean-options LaTeX-fixme-external-layouts)
  "FiXme external layout boolean options.")

(defvar LaTeX-fixme-layouts
  (sort (copy-sequence `(,@LaTeX-fixme-builtin-layouts
			 ,@LaTeX-fixme-external-layouts))
	#'string<)
  "FiXme layouts.")

(defvar LaTeX-fixme-layout-boolean-values
  (LaTeX-fixme-xkeyval-boolean-values LaTeX-fixme-layouts)
  "FiXme layout boolean values.")

(defvar LaTeX-fixme-layout-boolean-options
  (LaTeX-fixme-xkeyval-boolean-options LaTeX-fixme-layouts)
  "FiXme layout boolean options.")

;; #### FIXME: this is not totally correct. The layout, morelayout and
;; innerlayout options accept either a single value, or a comma-separated list
;; of such.
(defvar LaTeX-fixme-layout-options
  (sort (copy-sequence
	 `(,@LaTeX-fixme-layout-boolean-options
	   ("layout" ,LaTeX-fixme-layout-boolean-values)
	   ("morelayout" ,LaTeX-fixme-layout-boolean-values)
	   ("innerlayout" (,@LaTeX-fixme-layout-boolean-values
			   ("layout" ,LaTeX-fixme-layout-boolean-values)
			   ("morelayout",LaTeX-fixme-layout-boolean-values)))))
	#'LaTeX-fixme-option<)
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
  (sort (copy-sequence `(,@LaTeX-fixme-builtin-env-layouts
			 ,@LaTeX-fixme-external-env-layouts))
	#'string<)
  "FiXme environment layouts.")

(defvar LaTeX-fixme-envlayout-option
  `("envlayout" ,LaTeX-fixme-env-layouts)
  "FiXme envlayout option.")


;; Target layouts
;; --------------
(defvar LaTeX-fixme-builtin-target-layouts
  '("changebar" "plain")
  "FiXme builtin target layouts.")

(defvar LaTeX-fixme-external-target-layouts
  '("color" "colorcb")
  "FiXme external target layouts.")

(defvar LaTeX-fixme-target-layouts
  (sort (copy-sequence `(,@LaTeX-fixme-builtin-target-layouts
			 ,@LaTeX-fixme-external-target-layouts))
	#'string<)
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
  (sort (mapcar #'LaTeX-fixme-face-option LaTeX-fixme-common-faces)
	#'LaTeX-fixme-option<)
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
  (sort (copy-sequence `(,@LaTeX-fixme-common-faces
			 ,LaTeX-fixme-env-face ,LaTeX-fixme-target-face))
	#'string<)
  "FiXme faces.")

(defvar LaTeX-fixme-face-options
  (sort (mapcar #'LaTeX-fixme-face-option LaTeX-fixme-faces)
	#'LaTeX-fixme-option<)
  "FiXme face options.")


;; Logging
;; -------
(defvar LaTeX-fixme-logging-options
  (LaTeX-fixme-xkeyval-boolean-options '("silent"))
  "FiXme logging options.")


;; Languages
;; ---------
(defvar LaTeX-fixme-languages
  '("croatian" "danish" "english" "francais" "french" "german" "italian"
    "ngerman" "spanish")
  "FiXme Languages.")

;; #### NOTE: langtrack not included
(defvar LaTeX-fixme-language-options
  (sort `(,@(mapcar #'list LaTeX-fixme-languages)
	  ("lang" ,LaTeX-fixme-languages)
	  ("defaultlang" ,LaTeX-fixme-languages))
	#'LaTeX-fixme-option<)
  "FiXme options for language selection.")

(defvar LaTeX-fixme-langtrack-option
  (LaTeX-fixme-xkeyval-boolean-option "langtrack")
  "FiXme langtrack option.")


;; Authoring
;; ---------
;; #### NOTE: the mode, singleuser and multiuser options are obsolete in FiXme
;; 5, so I don't want to support them anymore.
(defvar LaTeX-fixme-author-option
  '("author")
  "FiXme author option.")


;; Themes
;; ------
(defvar LaTeX-fixme-themes
  '("color" "colorsig" "signature")
  "FiXme themes.")

(defvar LaTeX-fixme-theme-option
  `("theme" ,LaTeX-fixme-themes)
  "FiXme theme option.")


;; Macro-dependent
;; ---------------
(defun LaTeX-fixme-annotation-options (&optional targeted)
  "Return a specification for the optional argument to FiXme annotations.
Mostly all, except for envlayout, envface, langtrack and theme.
TARGETED is for the starred versions, where additional options
exist (targetlayout and targetface)."
  `[ TeX-arg-key-val
     ,(sort (copy-sequence `(,@LaTeX-fixme-status-options
			     ,@LaTeX-fixme-layout-options
			     ,@LaTeX-fixme-common-face-options
			     ,LaTeX-fixme-target-option
			     ,@(when targeted
				 `(,LaTeX-fixme-targetlayout-option
				   ,LaTeX-fixme-target-face-option))
			     ,@LaTeX-fixme-logging-options
			     ,@LaTeX-fixme-language-options
			     ,LaTeX-fixme-author-option))
	    #'LaTeX-fixme-option<) ])

;; #### WARNING: gross hack. This function makes the targeted annotations look
;; like they're taking a single mandatory argument, whereas they actually take
;; 2.
(defun LaTeX-fixme-targeted-annotation-hack (optional)
  "Hook for targeted FiXme annotations.
This function inserts a first couple of braces and a second one,
potentially with the active region's contents within it. The point is left
inside the first couple of braces."
  (TeX-argument-insert "" nil)
  (TeX-parse-argument optional nil))


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

;; #### NOTE: OPTIONALP is ignored.
(defun LaTeX-fixme-boolean-option-definition (optionalp)
  "Hook for boolean option definitions.
Prompt for, and insert a key between braces.
When TeX-insert-macro is called with a prefix argument, first insert an empty
pair of square brackets for a function definition, and leave point inside."
  (cond (current-prefix-arg
	 (insert "[")
	 (let ((point (point)))
	   (insert "]")
	   (TeX-arg-string nil "Key")
	   (goto-char point)))
	(t
	 (TeX-arg-string nil "Key"))))


;; Environment-dependent
;; ---------------------
;; #### NOTE: this function compensates for the fact that AUCTeX doesn't
;; understand t arguments in environments as it does in macros (the point is
;; always left within the argument's body). The other solution (actually, the
;; previous one) was to prompt for the annotation summary, but I find that
;; less convenient to edit it in the minibuffer, rather than in the file
;; directly.
(defun LaTeX-fixme-insert-environment (environment)
  "Insert a FiXme annotation ENVIRONMENT.
Prompt for arguments, and leave point within the first couple of
braces, where the annotation summary needs to go.  For targeted
environments, use the active region as the second mandatory
argument."
  (let* ((targeted (string-match "\\*" environment))
	 (options-list (sort (copy-sequence
			      (append LaTeX-fixme-status-options
				      LaTeX-fixme-layout-options
				      LaTeX-fixme-common-face-options
				      LaTeX-fixme-logging-options
				      LaTeX-fixme-language-options
				      (list LaTeX-fixme-envlayout-option
					    LaTeX-fixme-env-face-option
					    LaTeX-fixme-target-option
					    LaTeX-fixme-author-option)
				      (when targeted
					(list LaTeX-fixme-targetlayout-option
					      LaTeX-fixme-target-face-option))))
			     #'LaTeX-fixme-option<))
	 (options (TeX-read-key-val t options-list))
	 (target (when (and targeted (TeX-active-mark))
		   (prog1 (buffer-substring (point) (mark))
		     (delete-region (point) (mark))))))
    (LaTeX-insert-environment
     environment
     (concat (when (and options (not (string= options "")))
	       (format "[%s]" options))
	     (concat TeX-grop TeX-grcl)
	     (when targeted
	       (concat TeX-grop target TeX-grcl))))
    (when target
      (LaTeX-fill-environment nil)
      (indent-according-to-mode)
      ;; #### NOTE: for some reason, doing this after DELETE-REGION doesn't
      ;; work (maybe something related to the insertion of the environment) so
      ;; I'm deferring it to here.
      (TeX-deactivate-mark))
    (LaTeX-find-matching-begin)
    (re-search-forward TeX-grcl)
    (when (= (char-after) ?\[)
      (forward-list))
    (forward-char)))



;; ===========================================================================
;; Style Hooks
;; ===========================================================================

(TeX-add-style-hook "fixme"
  (lambda ()

    (TeX-add-symbols
     `("fxsetup" (TeX-arg-key-val ,(sort (copy-sequence
					  `(,@LaTeX-fixme-status-options
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
					    ,LaTeX-fixme-theme-option))
					 #'LaTeX-fixme-option<)))

     `("fxnote"    ,(LaTeX-fixme-annotation-options) t)
     `("fxwarning" ,(LaTeX-fixme-annotation-options) t)
     `("fxerror"   ,(LaTeX-fixme-annotation-options) t)
     `("fxfatal"   ,(LaTeX-fixme-annotation-options) t)
     ;; #### NOTE: \fixme is obsolete so I don't want to support it here.

     `("fxnote*"    ,(LaTeX-fixme-annotation-options t)
       LaTeX-fixme-targeted-annotation-hack)
     `("fxwarning*" ,(LaTeX-fixme-annotation-options t)
       LaTeX-fixme-targeted-annotation-hack)
     `("fxerror*"   ,(LaTeX-fixme-annotation-options t)
       LaTeX-fixme-targeted-annotation-hack)
     `("fxfatal*"   ,(LaTeX-fixme-annotation-options t)
       LaTeX-fixme-targeted-annotation-hack)

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

     '("FXRegisterAuthor"
       ;; #### WARNING: this really is a dirty, dirty trick. We construct a
       ;; single argument out of 3, and let AUCTeX enclose the whole thing
       ;; with the missing pair of braces...
       (TeX-arg-eval
	let* ((tag (read-from-minibuffer "Tag: "))
	      (cmd (read-from-minibuffer "Command prefix: " (downcase tag)))
	      (env (read-from-minibuffer "Environment prefix: "
					 (concat "a" (downcase cmd)))))
	(concat          tag TeX-grcl
		TeX-grop cmd TeX-grcl
		TeX-grop env)))

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
			     (maybe-upcase-initials
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

    (let ((families '("Layout" "EnvLayout" "TargetLayout")))
      (apply #'TeX-add-symbols
	     (mapcar (lambda (macro)
		       (cons macro
			     '("Key" [ "Default" ] t)))
		     (mapcar (lambda (family) (concat "FXDefine" family "Key"))
			     families)))
      (apply #'TeX-add-symbols
	     (mapcar (lambda (macro)
		       (cons macro
			     '([ "Macro prefix" ] "Key" [ "Default" ] t)))
		     (mapcar (lambda (family)
			       (concat "FXDefine" family "CmdKey"))
			     families)))
      (apply #'TeX-add-symbols
	     (mapcar (lambda (macro)
		       (cons macro
			     '("Key" [ "Bin" ] "Alternatives" [ "Default" ] t)))
		     (mapcar (lambda (family)
			       (concat "FXDefine" family "ChoiceKey"))
			     families)))
      (apply #'TeX-add-symbols
	     (mapcar (lambda (macro) (cons macro '("Key" t)))
		     (mapcar (lambda (family)
			       (concat "FXDefine" family "VoidKey"))
			     families)))
      (apply #'TeX-add-symbols
	     (mapcar (lambda (macro)
		       (cons macro '(LaTeX-fixme-boolean-option-definition)))
		     (mapcar (lambda (family)
			       (concat "FXDefine" family "BoolKey"))
			     families))))

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
     `("anfxnote"    LaTeX-fixme-insert-environment)
     `("anfxwarning" LaTeX-fixme-insert-environment)
     `("anfxerror"   LaTeX-fixme-insert-environment)
     `("anfxfatal"   LaTeX-fixme-insert-environment)

     `("anfxnote*"    LaTeX-fixme-insert-environment)
     `("anfxwarning*" LaTeX-fixme-insert-environment)
     `("anfxerror*"   LaTeX-fixme-insert-environment)
     `("anfxfatal*"   LaTeX-fixme-insert-environment))


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

				 ("FXDefineLayoutKey" "{[{")
				 ("FXDefineEnvLayoutKey" "{[{")
				 ("FXDefineTargetLayoutKey" "{[{")

				 ("FXDefineLayoutCmdKey" "[{[{")
				 ("FXDefineEnvLayoutCmdKey" "[{[{")
				 ("FXDefineTargetLayoutCmdKey" "[{[{")

				 ("FXDefineLayoutChoiceKey" "{[{[{")
				 ("FXDefineEnvLayoutChoiceKey" "{[{[{")
				 ("FXDefineTargetLayoutChoiceKey" "{[{[{")

				 ("FXDefineLayoutVoidKey" "{{")
				 ("FXDefineEnvLayoutVoidKey" "{{")
				 ("FXDefineTargetLayoutVoidKey" "{{")

				 ("FXDefineLayoutBoolKey" "[{")
				 ("FXDefineEnvLayoutBoolKey" "[{")
				 ("FXDefineTargetLayoutBoolKey" "[{")

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
