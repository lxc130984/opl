;;; opl-struct.el --- Robust Typst previews for Org mode -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;;------------------------------------------------------------------------------
;; 基本结构
;;------------------------------------------------------------------------------
(require 'cl-lib)


(cl-defstruct opl-node
  "The tree node for trait impl and struct."
  head
  children)

(cl-defstruct opl-element
  "The meta element in opl."
  file
  marker)



(cl-defstruct opl-content-node
  "The tree node for trait impl and struct with content."
  head
  content
  children)

(cl-defstruct (opl-trait (:include opl-element))
  "The trait."
  name
  trait-tree)

(cl-defstruct (opl-impl (:include opl-element))
  "The impl."
  trait
  struct
  introduction
  detail-tree)

(cl-defstruct (opl-struct (:include opl-element))
  "The struct."
  name
  introduction
  struct-tree)

(provide 'opl-struct)
;;; opl-struct.el ends here
