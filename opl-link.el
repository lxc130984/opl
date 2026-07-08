;;; opl-struct.el --- Robust Typst previews for Org mode -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;;------------------------------------------------------------------------------
;; 检查 todo:更详细的文档
;;------------------------------------------------------------------------------
(require 'opl-struct)
(require 'opl-parse)

(defun opl--get-autolink-marker ()
  "Get the marker that is autolink to."
  (when (member "autolink" (org-get-tags nil t))
    (save-excursion
      (goto-char (line-beginning-position))
      (when (re-search-forward org-link-any-re (line-end-position) t)
	(goto-char (match-beginning 0))
	(save-window-excursion
	  (org-open-at-point)
	  (copy-marker (point)))))))

(defun opl--marker-equal (m1 m2)
  "If equal M1 and M2."
  (and m1 m2
       (eq (marker-buffer m1) (marker-buffer m2))
       (= (marker-position m1) (marker-position m2))))

(defun opl--delete-autolinks (impl)
  "Removes the autolinks with :autolink: tags accroading IMPL."
  (opl--with-file-buffer (opl-impl-struct impl)
			   (lambda ()
			     (org-map-entries
			      (lambda ()
				(when-let* ((struct-target (opl--get-autolink-marker))
					    (impl-target (opl-impl-marker impl))
					    (_ (opl--marker-equal struct-target impl-target)))
				  (kill-whole-line)))
			      nil
			      'tree
			      'comment)))
  
  (opl--with-file-buffer (opl-impl-trait impl)
			   (lambda ()
			     (org-map-entries
			      (lambda ()
				(when-let* ((trait-target (opl--get-autolink-marker))
					    (impl-target (opl-impl-marker impl))
					    (_ (opl--marker-equal trait-target impl-target)))
				  (kill-whole-line)))
			      nil
			      'tree
			      'comment))))

(defun opl--with-file-buffer (obj fn)
  "Open the file buffer and funcall FN.OBJ is a trait or a struct or a impl."
  (let ((buf (or (find-buffer-visiting (cond
					((opl-trait-p obj) (opl-trait-file obj))
					((opl-struct-p obj) (opl-struct-file obj))
					((opl-impl-p obj) (opl-impl-file obj))))
		 (find-file-noselect (cond
					((opl-trait-p obj) (opl-trait-file obj))
					((opl-struct-p obj) (opl-struct-file obj))
					((opl-impl-p obj) (opl-impl-file obj)))))))
    (with-current-buffer buf
      (save-excursion
	(goto-char (cond
		    ((opl-trait-p obj) (opl-trait-marker obj))
		    ((opl-struct-p obj) (opl-struct-marker obj))
		    ((opl-impl-p obj) (opl-impl-marker obj))))
	(funcall fn)))))

(defun opl--impl-delete-autolink (impl)
  "Accroading IMPL to delete the autolink."
  (opl--with-file-buffer (opl-impl-trait impl)
			 (lambda ()
			   (opl--delete-autolinks impl)))
  (opl--with-file-buffer (opl-impl-struct impl)
			 (lambda ()
			   (opl--delete-autolinks impl))))

(defun opl--impl-add-autolink (impl)
  "Accroading IMPL to add the autolink."
  (let ((impl-link (opl--with-file-buffer impl (lambda ()
						 (org-store-link nil nil))))
	(org-blank-before-new-entry '((heading . nil)
                                    (plain-list-item . nil))))             ;;默认情况下,org-insert-subheading会多余插入一行,需要把这个变量设置为这样才可以解决这个问题.
    (opl--with-file-buffer (opl-impl-trait impl)
			   (lambda ()
			     (forward-line 0)
			     (org-insert-subheading nil)
			     (insert impl-link)
			     (org-set-tags '("autolink"))))
    (opl--with-file-buffer (opl-impl-struct impl)
			   (lambda ()
			    (forward-line 0)
			    (org-insert-subheading nil)
			    (insert impl-link)
			    (org-set-tags '("autolink"))))))


(provide 'opl-link)
;;; opl-link.el ends here
