# AIAOS-Cloel-RSI

AIAOS-Cloel-RSI is an Emacs + Clojure integration framework that provides a high-performance, asynchronous backend for Emacs.

## Architecture

```
Emacs (elisp) → Cloel (elisp + clojure) → Clojure Server → AIAOS Framework (clojure)
```

## Features

- **M-x aiaos-rsi**: Launch the AIAOS-RSI interface
- **Status monitoring**: Monitor all layers (Emacs, Cloel, Clojure, AIAOS)
- **LLM Provider integration**: Multiple LLM providers with automatic failover
- **Command execution**: Execute commands through the AIAOS framework
- **Self-evolution**: Framework that improves itself over time

## Installation

### Prerequisites

- Emacs 27+
- Clojure 1.11+

### Setup

1. Clone or download the project to `~/.emacs.d/aiaos-cloel-rsi`
2. Add the following to your `~/.emacs`:

```elisp
(load-file "~/.emacs.d/aiaos-cloel-rsi/aiaos-cloel-rsi.el")
```

3. Restart Emacs

## Usage

### Launch the UI

```elisp
M-x aiaos-rsi
```

### Execute a command

```elisp
M-x aiaos-cloel-rsi-execute
```

### Show status

```elisp
M-x aiaos-cloel-rsi-status
```

## Configuration

### LLM Provider

Edit `~/.emacs.d/aiaos-cloel-rsi/config.edn` to configure LLM providers:

```clojure
{:llm {:provider "openrouter"
       :api-key "your-api-key-here"
       :model "mistralai/mistral-7b-instruct"}}
```

### Server Port

Edit `~/.emacs.d/aiaos-cloel-rsi/aiaos-cloel-rsi.el` to change the server port:

```elisp
(defcustom aiaos-cloel-rsi-clojure-server-port 8080
  "Port for the Clojure server."
  ...)
```

## Project Structure

```
aiaos-cloel-rsi/
├── aiaos-cloel-rsi.el          # Main elisp file
├── aiaos-cloel-rsi-ui.el       # UI definitions
├── aiaos-cloel-rsi-clojure.el  # Clojure server wrapper
├── project.clj                 # Clojure project configuration
├── src/
│   └── aiaos_cloel_rsi/
│       ├── server.clj          # Clojure server
│       ├── aiaos_framework.clj # AIAOS framework (Clojure)
│       └── llm_provider.clj    # LLM provider integration
└── README.md
```

## Architecture Details

### Emacs Layer (elisp)

Provides the user interface and command entry point. Communicates with the Clojure server via HTTP.

### Cloel Layer (elisp + clojure)

The gateway between Emacs and Clojure. Handles protocol translation and request routing.

### Clojure Layer (clojure)

The high-performance backend. Handles command processing, LLM integration, and framework management.

### AIAOS Layer (clojure)

The core AIAOS framework implementation in Clojure. Provides command processing, self-evolution, and auto-improvement.

## License

GNU General Public License v3.0