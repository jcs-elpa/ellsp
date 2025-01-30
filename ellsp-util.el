;;; ellsp-util.el --- Util module  -*- lexical-binding: t; -*-

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
;; Util module.
;;

;;; Code:

(defun ellsp-2str (obj)
  "Convert OBJ to string."
  (format "%s" obj))

(defmacro ellsp-current-buffer (buffer &rest body)
  "Execute BODY with in a valid BUFFER."
  (declare (indent 1))
  `(when ,buffer
     (with-current-buffer ,buffer
       (goto-char (point-min))
       ,@body)))

(provide 'ellsp-util)
;;; ellsp-util.el ends here
