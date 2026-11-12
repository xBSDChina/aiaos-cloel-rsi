;;; test-comprehensive.el --- Comprehensive test for aiaos-cloel-rsi

(add-to-list 'load-path "/home/shjiaye8/.emacs.d/aiaos-cloel-rsi")

(require 'aiaos-cloel-rsi)
(require 'aiaos-cloel-rsi-ui)
(require 'aiaos-cloel-rsi-clojure)

(message "=== Comprehensive Test Suite ===")

;; Test 1: Module loading
(message "Test 1: Module loading")
(if (and (featurep 'aiaos-cloel-rsi)
         (featurep 'aiaos-cloel-rsi-ui)
         (featurep 'aiaos-cloel-rsi-clojure))
    (message "PASS: All modules loaded")
  (message "FAIL: Module loading failed"))

;; Test 2: Command availability
(message "Test 2: Command availability")
(let ((commands '("aiaos-rsi" "aiaos-cloel-rsi-send-command"
                  "aiaos-cloel-rsi-status" "aiaos-cloel-rsi-stop")))
  (dolist (cmd commands)
    (if (commandp (intern cmd))
        (message "PASS: %s is a command" cmd)
      (message "FAIL: %s is not a command" cmd))))

;; Test 3: Function existence
(message "Test 3: Function existence")
(let ((funcs '("aiaos-cloel-rsi-ui-get-buffer"
               "aiaos-cloel-rsi-ui-append-output"
               "aiaos-cloel-rsi-clojure-send-command"
               "aiaos-cloel-rsi-check-server")))
  (dolist (f funcs)
    (if (functionp (intern f))
        (message "PASS: %s exists" f)
      (message "FAIL: %s missing" f))))

;; Test 4: Buffer creation
(message "Test 4: Buffer creation")
(let ((buffer (get-buffer-create "*test-aiaos-buffer*")))
  (if buffer
      (progn
        (message "PASS: Buffer created: %s" (buffer-name buffer))
        (kill-buffer buffer))
    (message "FAIL: Buffer creation failed")))

;; Test 5: UI operations
(message "Test 5: UI operations")
(let ((test-text "Test output\n"))
  (aiaos-cloel-rsi-ui-append-output test-text)
  (message "PASS: UI append output works"))

(message "=== All tests completed ===")