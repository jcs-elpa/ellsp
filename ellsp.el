;;; ellsp.el --- Elisp Language Server  -*- lexical-binding: t; -*-

;; Copyright (C) 2023-2025  Shen, Jen-Chieh

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Maintainer: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/elisp-lsp/ellsp
;; Version: 0.2.0
;; Package-Requires: ((emacs "27.1") (lsp-mode "6.0.1") (log4e "0.1.0") (dash "2.14.1") (s "1.12.0") (company "0.8.12") (msgu "0.1.0"))
;; Keywords: convenience lsp

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
;; Elisp Language Server.
;;

;;; Code:

(require 'cl-lib)
(require 'pcase)
(require 'lsp-mode)
(require 'dash)
(require 's)
(require 'msgu)

(require 'ellsp-util)
(require 'ellsp-log)
(require 'ellsp-tdsync)
(require 'ellsp-completion)
(require 'ellsp-hover)
(require 'ellsp-signature)
(require 'ellsp-code-action)

(defconst ellsp-version "0.2.0"
  "The elisp langauge server version.")

(defgroup ellsp nil
  "Elisp Language Server."
  :prefix "ellsp-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/elisp-lsp/ellsp"))

(defcustom ellsp-eol (pcase system-type
                       ;; XXX: Don't know why `\r\n' does not work with VSCode
                       ;; on Window; and don't know why `\n' will work...
                       (`windows-nt "\n")
                       (_           "\r\n"))
  "EOL for send messages."
  :type 'string
  :group 'ellsp)

(defvar ellsp--running-p t
  "Non-nil when the server is still running.")

(defvar ellsp--initialized-p nil
  "Non-nil when it initialize successfully.")

(defcustom ellsp-initialized-hook nil
  "Hook runs after the server is initialized."
  :type 'hook
  :group 'ellsp)

(defun ellsp-send-response (msg)
  "Send response MSG."
  (when (or (hash-table-p msg)
            (and (listp msg) (plist-get msg :jsonrpc)))
    (setq msg (lsp--json-serialize msg)))
  (setq msg (concat "Content-Length: "
                    (ellsp-2str (string-bytes msg))
                    ellsp-eol ellsp-eol
                    msg))
  (princ msg)
  (terpri)
  msg)

(defun ellsp--initialize (id)
  "Initialize the language server."
  (lsp--make-response
   id
   (lsp-make-initialize-result
    :server-info (lsp-make-server-info
                  :name "ellsp"
                  :version? ellsp-version)
    :capabilities (lsp-make-server-capabilities
                   :hover-provider? t
                   :text-document-sync? (lsp-make-text-document-sync-options
                                         :open-close? t
                                         :save? t
                                         :change? 1)
                   :code-action-provider? (lsp-make-code-action-options
                                           :resolve-provider? json-false)
                   :completion-provider? (lsp-make-completion-options
                                          :resolve-provider? json-false)
                   :signature-help-provider? (lsp-make-signature-help-options
                                              :trigger-characters? [" "])))))

(defun ellsp--initialized ()
  "After server initialization."
  (setq ellsp--initialized-p t)
  (run-hooks 'ellsp-initialized-hook)
  nil)

(defun ellsp--shutdown ()
  "Shutdown language server."
  (setq ellsp--running-p nil))

(defun ellsp--on-request (id method params)
  "On request callback."
  (message "method: %s" method)
  (let ((res
         (pcase method
           ("initialize"                 (ellsp--initialize id))
           ("initialized"                (ellsp--initialized))
           ("shutdown"                   (ellsp--shutdown))
           ("textDocument/didOpen"       (ellsp--handle-textDocument/didOpen params))
           ("textDocument/didSave"       (ellsp--handle-textDocument/didSave params))
           ("textDocument/didChange"     (ellsp--handle-textDocument/didChange params))
           ("textDocument/codeAction"    (ellsp--handle-textDocument/codeAction id params))
           ("textDocument/completion"    (ellsp--handle-textDocument/completion id params))
           ("textDocument/hover"         (ellsp--handle-textDocument/hover id params))
           ("textDocument/signatureHelp" (ellsp--handle-textDocument/signatureHelp id params))
           ;; Emacs is single threaded, skip it.
           ("$/cancelRequest"            nil))))
    (cond ((not res)
           (message "<< %s" "no response"))
          ((when-let* ((res (ignore-errors (lsp--json-serialize res))))
             (message "<< %s" res)
             (ellsp-send-response res)))
          ((when-let* ((res (ignore-errors (json-encode res))))
             (message "<< %s" res)
             (ellsp-send-response res)))
          (t
           (message "<< %s" "failed to send response")))))

(defun ellsp--get-content-length (input)
  "Return the content length from INPUT."
  (string-to-number (nth 1 (split-string input ": "))))

(defvar ellsp-next-input nil)

(defun ellsp-stdin-loop ()
  "Reads from standard input in a loop and process incoming requests."
  (ellsp--info "Starting the language server...")
  (let ((input)
        (content-length))
    (while (and ellsp--running-p
                (progn
                  (setq input (or ellsp-next-input
                                  (read-from-minibuffer "")))
                  input))
      (unless (string-empty-p input)
        ;; XXX: Function `s-replace' is used to avoid the following error:
        ;;
        ;; Invalid use of `\' in replacement text ...
        (ellsp--info (s-replace "\\" "\\\\" input)))
      (setq ellsp-next-input nil)  ; Reset
      (cond
       ((string-empty-p input) )
       ((and (null content-length)
             (string-prefix-p "content-length: " input t))
        (setq content-length (ellsp--get-content-length input)))
       (content-length
        (when (string-match-p "content-length: [0-9\r\n]+$" input)
          (with-temp-buffer
            (insert input)
            (when (search-backward "content-length: " nil t)
              (setq input (buffer-substring-no-properties (point-min) (point))
                    ellsp-next-input (buffer-substring-no-properties (point) (point-max))))))
        (-let* (((&JSONResponse :params :method :id) (lsp--read-json input)))
          (condition-case err
              (ellsp--on-request id method params)
            (error (ellsp--error "Ellsp error: %s"
                                 (error-message-string err)))))
        (setq content-length nil))))))

(provide 'ellsp)
;;; ellsp.el ends here
