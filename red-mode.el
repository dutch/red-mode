;;; red-mode.el --- Red editing mode -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Chris Lamberson

;; Author: Chris Lamberson <chris@lamberson.online>
;; Version: 0.1.0
;; Url: https://github.com/dutch/red-mode
;; Keywords: languages
;; Package-Requires: ((emacs "25.0"))

;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;

;;; Code:

(defgroup red-mode nil
  "Support for Red code."
  :link '(url-link "https://red-lang.org")
  :group 'languages)

(defcustom red-indent-offset 4
  "Number of spaces per indent level."
  :type 'integer
  :group 'red-mode)

(defvar red-mode-syntax-table
  (let ((table (make-syntax-table)))
	table)
  "Syntax table for Red major mode.")

(defvar red-mode-keywords
  '("func" "function"))

(defvar red-mode-constants
  '("Red"))

(defvar red-mode-font-lock-defaults
  `((("[\\|]" . font-lock-keyword-face)
	 (,(regexp-opt red-mode-keywords 'words) . font-lock-builtin-face)
	 (,(regexp-opt red-mode-constants 'words) . font-lock-constant-face))))

(defun red-indent-line ()
  "Indent current line as Red code."
  (interactive)
  (let* ((indent-level
		  (save-excursion
			(beginning-of-line)
			(cond ((not (re-search-backward "[]()[{}]" nil 'move))
				   0)
				  ((member (aref (match-string 0) 0) (string-to-list "[{("))
				   (let ((m (match-string 0)))
					 (+ (current-indentation) red-indent-offset)))
				  (t
				   (current-indentation))))))
	(if (save-excursion (beginning-of-line) (looking-at "[ \t]*[]})]"))
		(indent-line-to (- indent-level red-indent-offset))
	  (indent-line-to (max indent-level 0)))))

;;;###autoload
(define-derived-mode red-mode prog-mode "Red"
  "Major mode for Red code."
  :group 'red-mode
  :syntax-table red-mode-syntax-table
  (setq-local font-lock-defaults red-mode-font-lock-defaults)
  (setq-local indent-line-function 'red-indent-line))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.reds?\\'" . red-mode))

(provide 'red-mode)
;;; red-mode.el ends here
