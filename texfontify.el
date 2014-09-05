;;; texfontify.el --- print a fontified buffer using LaTeX

;; Package: texfontify
;; Filename: texfontify.el
;; Version: 0.1
;; Keywords: print, markup
;; Author: Joe Schafer
;; Created: 2014-09-04
;; Description: create a pdf of a fontified buffer
;; URL: http://github.com/jschaf/texfontify

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
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;


;;; Code:

(defun tfy-default-header (file style)
  "Default value for `hfy-page-header'.
FILE is the name of the file.
STYLE is the inline CSS stylesheet (or tag referring to an external sheet)."
  "")

(defun tfy-default-footer (&optional file)
  "Default value for `hfy-page-footer'.
FILE is the name of the file being rendered, in case it is needed."
  "")

(defun tfy-begin-span (style text-block text-id text-begins-block-point)
  "Default handler to begin a span of text."
  (insert (format "(%s " style)))

(defun tfy-end-span ()
  "Default handler to end a span of text."
  (insert ")\n"))

(defun tfy-strip-pre-tags ()
  "Remove html pre tags from output."
  (message "running hook")
  (save-excursion
    (let ((case-fold-search t)) ; or nil
      (goto-char (point-min))
      (while (search-forward-regexp "\n</?pre>" nil t)
        (replace-match "" t t)))))

(add-hook 'hyf-post-html-hook 'tfy-strip-pre-tags)

(defun texfontify-buffer (&optional srcdir file)
  "Create a new buffer, named for the current buffer."
  (interactive)
  (let (html-parse-tree
        (hfy-page-header 'tfy-default-header)
        (hfy-page-footer 'tfy-default-footer)
        ;; (hfy-begin-span-handler 'tfy-begin-span)
        ;; (hfy-end-span-handler 'tfy-end-span)
        )

    (call-interactively 'htmlfontify-buffer)
    (tfy-strip-pre-tags)
    (goto-char (point-min))


    (setq html-parse-tree (libxml-parse-html-region (point-min) (point-max)))

    (with-current-buffer "joejoe"
      (erase-buffer)
      (insert (format "%s" html-parse-tree)))

    ))

(provide 'texfontify)

;; Local Variables:
;; coding: utf-8
;; End:

;;; texfontify.el ends here
