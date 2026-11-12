;;; test-aiaos-cloel-rsi-emacsclient.el --- emacsclient tests for aiaos-cloel-rsi -*- lexical-binding: t; -*-

;; Copyright (C) 2026 AIAOS-Cloel-RSI Project
;; Author: AIAOS Framework

;; Tests for aiaos-cloel-rsi module using emacsclient

(add-to-list 'load-path "/home/shjiaye8/.emacs.d/aiaos-cloel-rsi")

(require 'aiaos-cloel-rsi)

;; Test 1: Check that aiaos-cloel-rsi command is available
(message "Test 1: Checking aiaos-cloel-rsi command availability")
(if (commandp 'aiaos-cloel-rsi)
    (message "PASS: aiaos-cloel-rsi is a command")
  (message "FAIL: aiaos-cloel-rsi is not a command"))

;; Test 2: Check that aiaos-cloel-rsi-send-command command is available
(message "Test 2: Checking aiaos-cloel-rsi-send-command command availability")
(if (commandp 'aiaos-cloel-rsi-send-command)
    (message "PASS: aiaos-cloel-rsi-send-command is a command")
  (message "FAIL: aiaos-cloel-rsi-send-command is not a command"))

;; Test 3: Check that aiaos-cloel-rsi-ui-buffer-name is defined
(message "Test 3: Checking aiaos-cloel-rsi-ui-buffer-name")
(if (boundp 'aiaos-cloel-rsi-ui-buffer-name)
    (message "PASS: aiaos-cloel-rsi-ui-buffer-name is defined")
  (message "FAIL: aiaos-cloel-rsi-ui-buffer-name is not defined"))

;; Test 4: Check that aiaos-cloel-rsi-mode is defined
(message "Test 4: Checking aiaos-cloel-rsi-ui-mode definition")
(if (functionp 'aiaos-cloel-rsi-ui-mode)
    (message "PASS: aiaos-cloel-rsi-ui-mode is defined")
  (message "FAIL: aiaos-cloel-rsi-ui-mode is not defined"))

;; Test 5: Check that aiaos-cloel-rsi-clojure functions exist
(message "Test 5: Checking aiaos-cloel-rsi-clojure functions")
(if (and (functionp 'aiaos-cloel-rsi-start-clojure-server)
         (functionp 'aiaos-cloel-rsi-stop-clojure-server)
         (functionp 'aiaos-cloel-rsi-send-command))
    (message "PASS: Clojure functions exist")
  (message "FAIL: Clojure functions missing"))

;; Test 6: Create a buffer and verify it works
(message "Test 6: Testing buffer creation")
(let ((buffer (get-buffer-create aiaos-cloel-rsi-ui-buffer-name)))
  (if buffer
      (progn
        (message "PASS: Buffer created: %s" (buffer-name buffer))
        (kill-buffer buffer))
    (message "FAIL: Buffer creation failed")))

(message "All tests completed")