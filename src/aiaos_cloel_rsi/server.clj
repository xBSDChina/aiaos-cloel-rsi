(ns aiaos-cloel-rsi.server
  (:require [clojure.core.async :refer [>!! <!! chan go timeout]]
            [aiaos-cloel-rsi.aiaos-framework :as framework]
            [aiaos-cloel-rsi.llm-provider :as llm]
            [ring.adapter.jetty :as jetty]
            [ring.util.request :as request]
            [ring.util.response :as response]
            [cheshire.core :as json])
  (:import [java.io IOException]))

;; Server state
(defonce server-port 8080)
(defonce server-state (atom {:running false
                             :commands-processed 0
                             :errors 0}))

;; Command channel
(def command-chan (chan 100))
(def result-chan (chan 100))

;; Logging
(defn log
  "Simple logging function."
  [level message]
  (println (str "[" level "] " (java.time.LocalDateTime/now) " - " message)))

;; HTTP Request Handler
(defn app
  "Ring handler for AIAOS-Cloel-RSI."
  [request]
  (case (:uri request)
    "/" (response/content-type (response/response "AIAOS-Cloel-RSI Server is running!") "text/plain")
    "/status" (response/content-type (response/response (json/generate-string @server-state)) "application/json")
    "/process" (let [body (slurp (:body request))
                     command (json/parse-string body true)]
                 (response/content-type (response/response (json/generate-string {:result "processed" :command command})) "application/json"))
    (response/content-type (response/status (response/response "Not Found") 404) "text/plain")))

;; Command Processor
(defn start-command-processor
  "Start processing commands from the command channel."
  []
  (go
    (while true
      (when-let [cmd (<!! command-chan)]
        (try
          (let [result (framework/process-command cmd)]
            (>!! result-chan result)
            (swap! server-state update :commands-processed inc))
          (catch Exception e
            (log "ERROR" (str "Command processing failed: " (.getMessage e)))
            (swap! server-state update :errors inc)))))))

;; Server Lifecycle
(defn start-server
  "Start the Clojure server."
  []
  (log "INFO" "Starting AIAOS-Cloel-RSI server...")
  (swap! server-state assoc :running true)
  (log "INFO" (format "Server running on port %d" server-port))
  (jetty/run-jetty app {:port server-port}))

(defn stop-server
  "Stop the Clojure server."
  []
  (log "INFO" "Stopping AIAOS-Cloel-RSI server...")
  (swap! server-state assoc :running false)
  (log "INFO" "Server stopped."))

;; Status API
(defn get-status
  "Get the server status."
  []
  @server-state)

;; Main entry point
(defn -main
  "Main entry point."
  [& args]
  (log "INFO" "AIAOS-Cloel-RSI Server v1.0.0")
  (log "INFO" "Initializing...")
  
  ;; Initialize LLM provider
  (llm/init)
  
  ;; Start server
  (start-server))

;; For REPL development
(defn restart
  "Restart the server."
  []
  (stop-server)
  (Thread/sleep 1000)
  (start-server))