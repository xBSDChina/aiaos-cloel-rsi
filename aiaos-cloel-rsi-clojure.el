;;; aiaos-cloel-rsi-clojure.el --- AIAOS-Cloel-RSI Clojure Server

;; Copyright (C) 2026 AIAOS-Cloel-RSI Project

;; This file is part of aiaos-cloel-rsi.

;;; Commentary:
;; Emacs-side wrapper for the Clojure server.
;; Handles HTTP communication with the Clojure backend.

;;; Code:

(require 'json)
(require 'url)

;; Process handle
(make-variable-buffer-local
 (defvar aiaos-cloel-rsi-clojure-process nil
  "The Clojure server process."))

;; HTTP endpoints
(defcustom aiaos-cloel-rsi-http-host "http://localhost"
  "HTTP host for the Clojure server."
  :type 'string
  :group 'aiaos-cloel-rsi)

(defcustom aiaos-cloel-rsi-http-port 8080
  "HTTP port for the Clojure server."
  :type 'integer
  :group 'aiaos-cloel-rsi)

(defun aiaos-cloel-rsi-http-url (path)
  "Construct HTTP URL for PATH."
  (format "%s:%d%s" aiaos-cloel-rsi-http-host aiaos-cloel-rsi-http-port path))

;;;###autoload
(defun aiaos-cloel-rsi-start-clojure-server ()
  "Start the Clojure server."
  (interactive)
  (if aiaos-cloel-rsi-clojure-process
      (message "Clojure server already running")
    (let ((cmd (format "cd %s && clojure -M -m aiaos-cloel-rsi.server"
                       aiaos-cloel-rsi-project-dir)))
      (message "Starting Clojure server: %s" cmd)
      (condition-case err
          (progn
            (setq aiaos-cloel-rsi-clojure-process
                  (start-process "aiaos-cloel-rsi-clojure" nil "bash" "-c" cmd))
            (message "Clojure server started with PID %s"
                     (process-id aiaos-cloel-rsi-clojure-process))
            ;; Wait a bit for server to start
            (sleep-for 2)
            ;; Check if server is responsive
            (aiaos-cloel-rsi-check-server))
        (error
         (message "Failed to start Clojure server: %s" (error-message-string err))
         (setq aiaos-cloel-rsi-clojure-process nil))))))

;;;###autoload
(defun aiaos-cloel-rsi-check-server ()
  "Check if the Clojure server is responsive."
  (condition-case err
      (let ((buffer (url-retrieve-synchronous (aiaos-cloel-rsi-http-url "/status") nil nil 5000)))
        (if buffer
            (with-current-buffer buffer
              (goto-char (point-min))
              (if (re-search-forward "200" nil t)
                  (progn
                    (message "Server is responsive")
                    (kill-buffer (current-buffer))
                    t)
                (message "Server not responsive")
                (kill-buffer (current-buffer))
                nil))
          (message "Server check failed: no response")
          nil))
    (error
     (message "Server check failed: %s" (error-message-string err))
     nil)))

;;;###autoload
(defun aiaos-cloel-rsi-stop-clojure-server ()
  "Stop the Clojure server."
  (interactive)
  (when aiaos-cloel-rsi-clojure-process
    (delete-process aiaos-cloel-rsi-clojure-process)
    (setq aiaos-cloel-rsi-clojure-process nil)
    (message "Clojure server stopped")))

;;;###autoload
(defun aiaos-cloel-rsi-clojure-send-command (command)
  "Send COMMAND to the Clojure server via HTTP."
  (interactive "sCommand: ")
  (message "Sending command: %s" command)
  (condition-case err
      (let* ((payload (json-encode (list :command command)))
             (url-request-method "POST")
             (url-request-data payload)
             (url-request-extra-headers '((Content-Type . "application/json"))))
        (url-retrieve (aiaos-cloel-rsi-http-url "/process")
                     (lambda (status)
                       (condition-case err
                           (with-current-buffer (current-buffer)
                             (goto-char (point-min))
                             (if (re-search-forward "\\n\\n" nil t)
                                 (let ((response (json-read)))
                                   (message "Response: %s" (json-encode response))
                                   (aiaos-cloel-rsi-ui-append-output (format "✓ Response: %s\n" (json-encode response)))
                                   (kill-buffer (current-buffer)))
                               (message "No response from server")
                               (kill-buffer (current-buffer))))
                         (error
                          (message "Failed to process response: %s" (error-message-string err))
                          (aiaos-cloel-rsi-ui-append-output (format "✗ Error: %s\n" (error-message-string err))))))))
    (error
     (message "Failed to send command: %s" (error-message-string err))
     (aiaos-cloel-rsi-ui-append-output (format "✗ Error: %s\n" (error-message-string err))))))

(provide 'aiaos-cloel-rsi-clojure)

;;; aiaos-cloel-rsi-clojure.el ends here