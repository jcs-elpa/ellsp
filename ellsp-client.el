;;; ellsp-client.el --- Language client  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Shen, Jen-Chieh

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Language client.
;;

;;; Code:

(require 'lsp-mode)

(require 'ellsp-util)

(defun ellsp--executable ()
  "Return the language server executable name."
  (pcase system-type
    (`windows-nt "ellsp.exe")
    (_           "ellsp")))

;;;###autoload
(defun ellsp-register ()
  "Register to start using this language server."
  (interactive)
  (add-to-list 'lsp-language-id-configuration '(emacs-lisp-mode . "emacs-lisp"))
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection
     (lambda ()
       (cond ((locate-dominating-file (buffer-file-name) "Eask")
              (list "eask" "exec" (ellsp--executable)))
             (t (error "Ellsp Language Server can only run with Eask")))))
    :major-modes '(emacs-lisp-mode)
    :priority 1
    :server-id 'ellsp)))

(provide 'ellsp-client)
;;; ellsp-client.el ends here
