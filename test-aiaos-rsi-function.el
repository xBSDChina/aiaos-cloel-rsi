;;; test-aiaos-rsi-function.el --- Test aiaos-rsi function

(add-to-list 'load-path "/home/shjiaye8/.emacs.d/aiaos-cloel-rsi")
(require 'aiaos-cloel-rsi)

(message "Testing aiaos-rsi function...")
(let ((buf (get-buffer-create "*test-aiaos-rsi*")))
  (with-current-buffer buf
    (aiaos-cloel-rsi-ui-render)
    (message "Buffer created: %s" (buffer-name buf)))
  (kill-buffer buf))
(message "Test completed")