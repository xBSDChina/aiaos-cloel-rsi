(ns aiaos-cloel-rsi.aiaos-framework
  (:require [clojure.core.async :refer [>!! <!! chan go timeout]]
            [aiaos-cloel-rsi.llm-provider :as llm]
            [clojure.java.shell :as shell]))

;; AIAOS Framework - Clojure Implementation
;; This module provides the core AIAOS framework functionality
;; in Clojure, enabling high-performance async processing.

(defonce framework-state (atom {:initialized false
                                 :commands-processed 0
                                 :last-command nil}))

(defn init
  "Initialize the AIAOS framework."
  []
  (println "Initializing AIAOS Framework (Clojure)...")
  (swap! framework-state assoc :initialized true)
  (println "AIAOS Framework initialized"))

;; Forward declarations for all functions used in process-command
(declare process-shell-command)
(declare process-llm-command)
(declare get-framework-status)
(declare get-help)

(defn process-command
  "Process a command through the AIAOS framework.
  
  Parameters:
    command - the command to process (string or map)
  
  Returns:
    result map with :status, :output, :timestamp"
  [command]
  (let [cmd (if (string? command)
              {:type :shell :command command}
              command)
        start-time (System/currentTimeMillis)]
    
    (try
      (let [result (case (:type cmd)
                     :shell (process-shell-command (:command cmd))
                     :llm (process-llm-command (:prompt cmd))
                     :status (get-framework-status)
                     :help (get-help)
                     {:type :unknown :command cmd})]
        
        (let [end-time (System/currentTimeMillis)
              final-result (merge result
                                  {:timestamp end-time
                                   :duration (- end-time start-time)})]
          (swap! framework-state update :commands-processed inc)
          (swap! framework-state assoc :last-command cmd)
          final-result))
      
      (catch Exception e
        (println "Error processing command:" (.getMessage e))
        {:status :error
         :error (.getMessage e)
         :timestamp (System/currentTimeMillis)}))))

(defn process-shell-command
  "Process a shell command."
  [command]
  (println "Processing shell command:" command)
  (try
    (let [result (shell/sh command)]
      {:status (if (= 0 (:exit result)) :success :error)
       :output (:out result)
       :error (:err result)
       :exit (:exit result)})
    (catch Exception e
      {:status :error :error (.getMessage e)})))

(defn process-llm-command
  "Process an LLM command."
  [prompt]
  (println "Processing LLM command:" prompt)
  (try
    (let [response (llm/ask prompt)]
      {:status :success
       :response response})
    (catch Exception e
      {:status :error :error (.getMessage e)})))

(defn get-framework-status
  "Get the framework status."
  []
  {:status :success
   :framework @framework-state
   :llm-status (llm/get-status)})

(defn get-help
  "Get help information."
  [{:keys [topic]}]
  {:status :success
   :help (case topic
           "shell" "Shell commands are executed via Clojure's shell function"
           "llm" "LLM commands are processed via the configured LLM provider"
           "framework" "AIAOS Framework provides command processing, LLM integration, and status monitoring"
           "General help: Send commands as maps with :type and appropriate fields")})

;; Self-evolution mechanism
(defn self-evolve
  "Analyze performance and evolve the framework."
  []
  (println "Running self-evolution analysis...")
  (let [state @framework-state]
    (println (format "Commands processed: %d" (:commands-processed state)))
    (println (format "Last command: %s" (:last-command state)))
    {:status :success
     :analysis {:commands-processed (:commands-processed state)
                :uptime (:uptime state)}}))

;; Auto-improvement loop
(defn start-auto-improvement
  "Start the auto-improvement loop."
  []
  (println "Starting auto-improvement loop...")
  (go
    (while true
      (do
        (self-evolve)
        (Thread/sleep 60000))))) ; Run every minute