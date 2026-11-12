;;; test-aiaos-cloel-rsi-batch.el --- Batch tests for aiaos-cloel-rsi -*- lexical-binding: t; -*-

;; Copyright (C) 2026 AIAOS-Cloel-RSI Project
;; Author: AIAOS Framework

;; Tests for aiaos-cloel-rsi module using emacs --batch

;; Add current directory to load-path
(add-to-list 'load-path "/home/shjiaye8/.emacs.d/aiaos-cloel-rsi")

(require 'ert)
(require 'aiaos-cloel-rsi)

(ert-deftest aiaos-cloel-rsi-test-buffer-creation ()
  "Test that aiaos-cloel-rsi buffer can be created."
  (let ((buffer (get-buffer-create aiaos-cloel-rsi-ui-buffer-name)))
    (should buffer)
    (should (buffer-name buffer))
    (kill-buffer buffer)))

(ert-deftest aiaos-cloel-rsi-test-mode-definition ()
  "Test that aiaos-cloel-rsi-ui-mode is defined."
  (should (functionp 'aiaos-cloel-rsi-ui-mode)))

(ert-deftest aiaos-cloel-rsi-test-send-command ()
  "Test that aiaos-cloel-rsi-send-command exists."
  (should (commandp 'aiaos-cloel-rsi-send-command)))

(ert-deftest aiaos-cloel-rsi-test-start-server ()
  "Test that aiaos-cloel-rsi-start-clojure-server exists."
  (should (functionp 'aiaos-cloel-rsi-start-clojure-server)))

(ert-deftest aiaos-cloel-rsi-test-stop-server ()
  "Test that aiaos-cloel-rsi-stop-clojure-server exists."
  (should (functionp 'aiaos-cloel-rsi-stop-clojure-server)))

(ert-deftest aiaos-cloel-rsi-test-ui-functions ()
  "Test that UI functions exist."
  (should (and (functionp 'aiaos-cloel-rsi-ui)
               (functionp 'aiaos-cloel-rsi-ui-execute)
               (functionp 'aiaos-cloel-rsi-ui-status))))

(ert-run-tests-batch)