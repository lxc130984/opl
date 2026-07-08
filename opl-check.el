;;; opl-struct.el --- Robust Typst previews for Org mode -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
(require 'opl-struct)


(defun opl--conformity-for-impl (impl)
  "Check the conformity between IMPL."
  (let ((impl-node (opl-impl-detail-tree impl))
	(trait-node (opl-trait-trait-tree (opl-impl-trait impl))))
      (opl--tree-match impl-node trait-node)))

(defun opl--tree-match (impl-node trait-node)
  "Check the conformity between IMPL-NODE and TRAIT-NODE."
  (cl-every
   (lambda (trait-child-node)
     (let ((found (cl-find (opl-node-head trait-child-node)
			   (opl-content-node-children impl-node)
			   :key #'opl-content-node-head
			   :test #'string=)))
       (and found
	    (opl--tree-match found trait-child-node))))
   (opl-node-children trait-node)))


;;------------------------------------------------------------------------------
;; 检查 todo:更详细的文档
;;------------------------------------------------------------------------------

;; (defun opl--check-impl-validity (traits impls structs)
;;   "Check that IMPLS: referenced TRAITS and STRUCTS exists and whether the trait is fully implemented."
;;   (let ((errors nil))
;;     (dolist (impl impls)
;;       (let* ((struct-name (opl-impl-struct-name impl))
;; 	     (trait-name (opl-impl-trait-name impl))
;; 	     (struct-found (cl-find struct-name structs
;; 				    :key #'opl-struct-name :test #'string=))
;; 	     (trait-found (cl-find trait-name traits
;; 				   :key #'opl-trait-name :test #'string=)))
;; 	(unless struct-found
;; 	  (push (format "impl %s for %s do not find the struct : %s"
;; 			(opl-impl-struct-name impl)
;; 			(opl-impl-trait-name impl)
;; 			(opl-impl-struct-name impl)) errors))
;; 	(unless trait-found
;; 	  (push (format "impl %s for %s do not find the trati : %s"
;; 			(opl-impl-struct-name impl)
;; 			(opl-impl-trait-name impl)
;; 			(opl-impl-trait-name impl)) errors))
;; 	(when (and struct-found trait-found)
;; 	  (unless (opl-conformity impl trait-found)
;; 	    (push (format "impl %s for %s do not conformity with %s"
;; 			  (opl-impl-struct-name  impl)
;; 			  (opl-impl-trait-name impl)
;; 			  (opl-impl-trait-name impl)) errors)))))
;;     errors))



;; (defvar opl--checker '()
;;   "The checker.")

;; (defun opl--check (traits impls structs)
;;   "Check TRAITS IMPLS STRUCTS."
;;   (cl-loop for checker in opl--checker
;; 	   append (funcall checker traits impls structs)))

(provide 'opl-check)
;;; opl-check.el ends here
