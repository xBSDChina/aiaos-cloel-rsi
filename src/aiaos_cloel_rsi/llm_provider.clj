(ns aiaos-cloel-rsi.llm-provider
  (:require [clj-http.client :as client]
            [cheshire.core :as json]))

;; LLM Provider Integration
;; Supports multiple LLM providers with automatic failover.

(defonce llm-state (atom {:provider "openrouter"
                          :model "mistralai/mistral-7b-instruct"
                          :base-url "https://openrouter.ai/api/v1"
                          :api-key nil
                          :enabled false}))

(def providers
  "Configuration for available LLM providers."
  {"openrouter" {:name "OpenRouter"
                 :base-url "https://openrouter.ai/api/v1"
                 :models ["mistralai/mistral-7b-instruct"
                          "openai/gpt-3.5-turbo"
                          "anthropic/claude-3-opus"]}
   
   "deepseek" {:name "DeepSeek"
               :base-url "https://api.deepseek.com/v1"
               :models ["deepseek-chat" "deepseek-coder"]}
   
   "ollama" {:name "Ollama"
             :base-url "http://localhost:11434/v1"
             :models ["llama2" "mistral" "codellama"]}})

(defn init
  "Initialize the LLM provider."
  []
  (println "Initializing LLM provider...")
  (swap! llm-state assoc :enabled true)
  (println "LLM provider initialized"))

(defn set-provider
  "Set the active LLM provider.
  
  Parameters:
    provider-key - key of the provider (e.g., \"openrouter\", \"deepseek\", \"ollama\")"
  [provider-key]
  (if-let [provider-config (get providers provider-key)]
    (do
      (swap! llm-state assoc
             :provider provider-key
             :model (first (:models provider-config))
             :base-url (:base-url provider-config))
      (println "Switched to provider:" provider-key)
      (:name provider-config))
    (do
      (println "Unknown provider:" provider-key)
      nil)))

(defn set-model
  "Set the active model for the current provider."
  [model-key]
  (let [provider-config (get providers (:provider @llm-state))]
    (if (and provider-config (some #(= % model-key) (:models provider-config)))
      (do
        (swap! llm-state assoc :model model-key)
        (println "Switched to model:" model-key)
        model-key)
      (do
        (println "Unknown model for current provider:" model-key)
        nil))))

(defn get-status
  "Get the LLM provider status."
  []
  {:provider (:provider @llm-state)
   :model (:model @llm-state)
   :base-url (:base-url @llm-state)
   :enabled (:enabled @llm-state)})

(defn ask
  "Ask the LLM a question.
  
  Parameters:
    prompt - the prompt to send
  
  Returns:
    The LLM response."
  [prompt]
  (if-not (:enabled @llm-state)
    (throw (ex-info "LLM provider not enabled" {}))
    (let [url (str (:base-url @llm-state) "/chat/completions")
          payload {:model (:model @llm-state)
                   :messages [{:role "user" :content prompt}]
                   :temperature 0.7
                   :max-tokens 1000}]
      (try
        (let [response (client/post url
                                   {:body (json/generate-string payload)
                                    :headers {"Content-Type" "application/json"}
                                    :socket-timeout 30000
                                    :connect-timeout 5000})
              body (json/parse-string (:body response) true)]
          (get-in body [:choices 0 :message :content]))
        (catch Exception e
          (println "LLM request failed:" (.getMessage e))
          (throw e))))))

(defn list-providers
  "List all available providers."
  []
  (keys providers))

(defn list-models
  "List available models for the current provider."
  []
  (let [provider-config (get providers (:provider @llm-state))]
    (:models provider-config [])))