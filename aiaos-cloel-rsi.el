;;; aiaos-cloel-rsi.el --- AIAOS-Cloel-RSI: Emacs + Clojure Integration Framework

;; Copyright (C) 2026 AIAOS-Cloel-RSI Project
;; Author: AIAOS Framework
;; Version: 1.0.0

;; This file is part of aiaos-cloel-rsi.
;; aiaos-cloel-rsi is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;;; Commentary:

;; AIAOS-Cloel-RSI provides an Emacs frontend for the AIAOS framework,
;; which is implemented in Clojure. It uses a cloel middleware to bridge
;; Emacs Lisp and Clojure.

;; Usage:
;;   M-x aiaos-rsi                - Launch the RSI interface
;;   M-x aiaos-cloel-rsi          - Same as above
;;   M-x aiaos-cloel-rsi-send-command - Send a command to backend
;;   M-x aiaos-cloel-rsi-status   - Show framework status
;;   M-x aiaos-cloel-rsi-stop    - Stop the framework

;;; Code:

;; Configuration
(defgroup aiaos-cloel-rsi nil
  "AIAOS-Cloel-RSI: Emacs + Clojure Integration Framework."
  :group 'tools
  :prefix "aiaos-cloel-rsi-")

(defcustom aiaos-cloel-rsi-project-dir "/home/shjiaye8/.emacs.d/aiaos-cloel-rsi"
  "Directory containing the AIAOS-Cloel-RSI project."
  :type 'directory
  :group 'aiaos-cloel-rsi)

(defcustom aiaos-cloel-rsi-auto-start nil
  "Automatically start the Clojure server when loading this module."
  :type 'boolean
  :group 'aiaos-cloel-rsi)

;; Lazy load dependencies
(unless (featurep 'aiaos-cloel-rsi-ui)
  (require 'aiaos-cloel-rsi-ui))
(unless (featurep 'aiaos-cloel-rsi-clojure)
  (require 'aiaos-cloel-rsi-clojure))

;;;###autoload
(defun aiaos-rsi ()
  "Launch the AIAOS RSI interface.
This is the main entry point for the AIAOS-Cloel-RSI framework."
  (interactive)
  (aiaos-cloel-rsi))

;;;###autoload
(defun aiaos-cloel-rsi ()
  "Launch the AIAOS-Cloel-RSI interface."
  (interactive)
  (aiaos-cloel-rsi-ui)
  (when aiaos-cloel-rsi-auto-start
    (aiaos-cloel-rsi-start-clojure-server)))

;;;###autoload
(defun aiaos-cloel-rsi-send-command (command)
  "Send COMMAND to the AIAOS backend."
  (interactive "sCommand: ")
  (aiaos-cloel-rsi-clojure-send-command command))

;;;###autoload
(defun aiaos-cloel-rsi-status ()
  "Show the status of all layers."
  (interactive)
  (aiaos-cloel-rsi-ui-show-status))

;;;###autoload
(defun aiaos-cloel-rsi-stop ()
  "Stop the AIAOS-Cloel-RSI framework."
  (interactive)
  (aiaos-cloel-rsi-stop-clojure-server))

(provide 'aiaos-cloel-rsi)

;;; aiaos-cloel-rsi.el ends here