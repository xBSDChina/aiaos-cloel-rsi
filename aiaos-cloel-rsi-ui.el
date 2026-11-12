;;; aiaos-cloel-rsi-ui.el --- AIAOS-Cloel-RSI UI

;; Copyright (C) 2026 AIAOS-Cloel-RSI Project

;; This file is part of aiaos-cloel-rsi.

;;; Commentary:
;; User interface for AIAOS-Cloel-RSI.

;;; Code:

;; Configuration
(defcustom aiaos-cloel-rsi-ui-buffer-name "*AIAOS-RSI*"
  "Name of the AIAOS-RSI buffer."
  :type 'string
  :group 'aiaos-cloel-rsi)

(defcustom aiaos-cloel-rsi-ui-width 80
  "Width of the AIAOS-RSI window."
  :type 'integer
  :group 'aiaos-cloel-rsi)

(defcustom aiaos-cloel-rsi-ui-height 25
  "Height of the AIAOS-RSI window."
  :type 'integer
  :group 'aiaos-cloel-rsi)

;; Buffer-local variables
(make-variable-buffer-local
 (defvar aiaos-cloel-rsi-ui-state 'idle
  "Current state of the UI: idle, running, error"))

(make-variable-buffer-local
 (defvar aiaos-cloel-rsi-ui-output ""
  "Output buffer for the UI."))

(make-variable-buffer-local
 (defvar aiaos-cloel-rsi-ui-input ""
  "Input field for the UI."))

;;; UI Functions

;;;###autoload
(defun aiaos-cloel-rsi-ui ()
  "Display the AIAOS-RSI UI."
  (interactive)
  (let ((buffer (get-buffer-create aiaos-cloel-rsi-ui-buffer-name)))
    (with-current-buffer buffer
      (aiaos-cloel-rsi-ui-render)
      (aiaos-cloel-rsi-ui-mode))
    (select-window (display-buffer buffer))
    (aiaos-cloel-rsi-ui-focus-input)))

(define-minor-mode aiaos-cloel-rsi-ui-mode
  "Minor mode for the AIAOS-RSI UI buffer."
  :init-value nil
  :lighter " AIAOS-RSI-UI"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-c") 'aiaos-cloel-rsi-ui-execute)
            (define-key map (kbd "C-c C-k") 'aiaos-cloel-rsi-ui-kill)
            (define-key map (kbd "C-c C-s") 'aiaos-cloel-rsi-ui-status)
            (define-key map (kbd "C-c C-q") 'aiaos-cloel-rsi-ui-quit)
            (define-key map (kbd "C-c C-l") 'aiaos-cloel-rsi-ui-clear)
            (define-key map (kbd "C-c C-r") 'aiaos-cloel-rsi-ui-restart)
            map))

(defun aiaos-cloel-rsi-ui-render ()
  "Render the AIAOS-RSI UI."
  (read-only-mode -1)
  (erase-buffer)
  (insert (aiaos-cloel-rsi-ui-header))
  (insert (aiaos-cloel-rsi-ui-status-section))
  (insert (aiaos-cloel-rsi-ui-input-section))
  (read-only-mode 1)
  (goto-char (point-min)))

(defun aiaos-cloel-rsi-ui-header ()
  "Return the header string for the UI."
  (concat
   "╔══════════════════════════════════════════════════════════╗\\\\n"
   "║           AIAOS-Cloel-RSI Framework v1.0.0              ║\\\\n"
   "╠══════════════════════════════════════════════════════════╣\\\\n"
   "║ Architecture: Emacs (elisp) → Cloel → Clojure → AIAOS  ║\\\\n"
   "╚══════════════════════════════════════════════════════════╝\\\\n\\\\n"))

(defun aiaos-cloel-rsi-ui-status-section ()
  "Return the status section string."
  (concat
   "┌─ Status ──────────────────────────────────────────────┐\\\\n"
   "│ Emacs Layer:    " (aiaos-cloel-rsi-ui-status-icon 'emacs) "        │\\\\n"
   "│ Cloel Layer:    " (aiaos-cloel-rsi-ui-status-icon 'cloel) "        │\\\\n"
   "│ Clojure Layer:  " (aiaos-cloel-rsi-ui-status-icon 'clojure) "       │\\\\n"
   "│ AIAOS Layer:    " (aiaos-cloel-rsi-ui-status-icon 'aiaos) "        │\\\\n"
   "└────────────────────────────────────────────────────────┘\\\\n\\\\n"))

(defun aiaos-cloel-rsi-ui-status-icon (layer)
  "Return a status icon for LAYER."
  (cond
   ((eq layer 'emacs) "●")
   ((eq layer 'cloel) "●")
   ((eq layer 'clojure) "●")
   ((eq layer 'aiaos) "●")
   (t "?")))

(defun aiaos-cloel-rsi-ui-input-section ()
  "Return the input section string."
  (concat
   "┌─ Input ───────────────────────────────────────────────┐\\\\n"
   "│ > \\\\n"
   "└────────────────────────────────────────────────────────┘\\\\n\\\\n"
   "Commands:\\\\n"
   "  C-c C-c  Execute command\\\\n"
   "  C-c C-s  Show status\\\\n"
   "  C-c C-k  Kill process\\\\n"
   "  C-c C-q  Quit\\\\n"
   "  C-c C-l  Clear output\\\\n"
   "  C-c C-r  Restart framework\\\\n"))

(defun aiaos-cloel-rsi-ui-focus-input ()
  "Move point to the input field."
  (goto-char (point-max))
  (forward-line -1)
  (end-of-line))

;;;###autoload
(defun aiaos-cloel-rsi-ui-execute ()
  "Execute the command in the input field."
  (interactive)
  (let ((cmd (aiaos-cloel-rsi-ui-get-input)))
    (when cmd
      (aiaos-cloel-rsi-send-command cmd)
      (aiaos-cloel-rsi-ui-append-output (format "→ %s\\\\n" cmd))
      (aiaos-cloel-rsi-ui-clear-input)
      (aiaos-cloel-rsi-ui-render))))

;;;###autoload
(defun aiaos-cloel-rsi-ui-kill ()
  "Kill the running process."
  (interactive)
  (aiaos-cloel-rsi-stop-clojure-server)
  (aiaos-cloel-rsi-ui-append-output "\\\\n⚠ Process killed\\\\n"))

;;;###autoload
(defun aiaos-cloel-rsi-ui-status ()
  "Show detailed status."
  (interactive)
  (aiaos-cloel-rsi-ui-show-status))

;;;###autoload
(defun aiaos-cloel-rsi-ui-quit ()
  "Quit the UI."
  (interactive)
  (aiaos-cloel-rsi-stop)
  (quit-window))

;;;###autoload
(defun aiaos-cloel-rsi-ui-clear ()
  "Clear the output."
  (interactive)
  (aiaos-cloel-rsi-ui-render))

;;;###autoload
(defun aiaos-cloel-rsi-ui-restart ()
  "Restart the framework."
  (interactive)
  (aiaos-cloel-rsi-stop-clojure-server)
  (sleep-for 1)
  (aiaos-cloel-rsi-start-clojure-server)
  (aiaos-cloel-rsi-ui-append-output "\\\\n✓ Framework restarted\\\\n"))

(defun aiaos-cloel-rsi-ui-get-input ()
  "Get the input from the UI."
  (save-excursion
    (goto-char (point-max))
    (forward-line -1)
    (beginning-of-line)
    (skip-chars-forward "> ")
    (buffer-substring-no-properties (point) (line-end-position))))

(defun aiaos-cloel-rsi-ui-clear-input ()
  "Clear the input field."
  (save-excursion
    (goto-char (point-max))
    (forward-line -1)
    (beginning-of-line)
    (skip-chars-forward "> ")
    (delete-region (point) (line-end-position))))

;;;###autoload
(defun aiaos-cloel-rsi-ui-show-status ()
  "Show detailed status information."
  (interactive)
  (let ((buffer (get-buffer aiaos-cloel-rsi-ui-buffer-name)))
    (if buffer
        (with-current-buffer buffer
          (read-only-mode -1)
          (goto-char (point-max))
          (insert "\\n┌─ Detailed Status ─────────────────────────────────┐\\n")
          (insert (format "│ Emacs Layer:    %s\\n" (aiaos-cloel-rsi-ui-status-icon 'emacs)))
          (insert (format "│ Cloel Layer:    %s\\n" (aiaos-cloel-rsi-ui-status-icon 'cloel)))
          (insert (format "│ Clojure Layer:  %s\\n" (aiaos-cloel-rsi-ui-status-icon 'clojure)))
          (insert (format "│ AIAOS Layer:    %s\\n" (aiaos-cloel-rsi-ui-status-icon 'aiaos)))
          (insert "└──────────────────────────────────────────────────────┘\\n")
          (read-only-mode 1)
          (goto-char (point-max)))
      (message "AIAOS-RSI UI buffer not found"))))

;;;###autoload
(defun aiaos-cloel-rsi-ui-append-output (text)
  "Append TEXT to the UI output."
  (let ((buffer (get-buffer aiaos-cloel-rsi-ui-buffer-name)))
    (when buffer
      (with-current-buffer buffer
        (read-only-mode -1)
        (goto-char (point-max))
        (insert text)
        (read-only-mode 1)
        (goto-char (point-max))))))

(defun aiaos-cloel-rsi-ui-get-buffer ()
  "Get or create the AIAOS-RSI UI buffer."
  (get-buffer-create aiaos-cloel-rsi-ui-buffer-name))

(provide 'aiaos-cloel-rsi-ui)

;;; aiaos-cloel-rsi-ui.el ends here