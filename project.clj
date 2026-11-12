(defproject aiaos-cloel-rsi "1.0.1"
  :description "AIAOS-Cloel-RSI: Emacs + Clojure Integration Framework"
  :author "AIAOS Framework"
  :license {:name "GNU General Public License v3.0"
            :url "https://www.gnu.org/licenses/gpl-3.0.html"}

  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.clojure/core.async "1.5.642"]
                 [clj-http "3.12.3"]
                 [cheshire "5.13.0"]]

  :main aiaos-cloel-rsi.server

  :profiles {:dev
             {:dependencies [[cider/cider-nrepl "0.28.3"]]}

             :test
             {:dependencies [[luminus/rimpresh "1.10.0"]]}})