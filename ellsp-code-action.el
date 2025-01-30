;;; ellsp-code-action.el --- Code action  -*- lexical-binding: t; -*-

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
;; Code action.
;;

;;; Code:

(require 'ellsp-util)

(defun ellsp--handle-textDocument/codeAction (id params)
  "Handle method `textDocument/codeAction'."
  (-let* (((&CodeActionParams :text-document (&TextDocumentIdentifier :uri)
                              :context (&CodeActionContext :diagnostics)
                              :range (&Range :start :end))
           params)
          (file (lsp--uri-to-path uri))
          (buffer (ellsp-get-buffer ellsp-workspace file)))
    (ellsp-current-buffer buffer
      (forward-line line)
      (forward-char character)
      )))

(provide 'ellsp-code-action)
;;; ellsp-code-action.el ends here
