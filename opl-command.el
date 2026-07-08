;;; opl-struct.el --- Robust Typst previews for Org mode -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;;------------------------------------------------------------------------------
;; command
;;------------------------------------------------------------------------------

(require 'opl-struct)
(require 'opl-parse)
(require 'opl-check)
(require 'opl-link)

(cl-defun opl-run (&optional file)
  "Run opl in FILE."
  (interactive)
  (let ((table (opl--collect-impls-in-file file)))
    (maphash  (lambda (k v)
		(when (opl--conformity-for-impl v)
		  (opl--impl-delete-autolink v)))
	      table)
    (maphash (lambda (k v)
	       (when (opl--conformity-for-impl v)
		 (opl--impl-add-autolink v)))
	     table)
    ))

(provide 'opl-command)
;;; opl-command.el ends here
