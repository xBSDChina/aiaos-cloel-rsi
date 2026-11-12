# 任务目标与基本框架

- 将cloel作为clojure与emacs elisp的中间件及网关
- 架构链路：emacs侧：elisp <---> cloel侧：elisp, clojure server,clojure client <---> clojure侧：clojure <--> aiaos框架侧：aiaos框架(纯clojure实现）
- 基本交互模型：与LLM Provider交互，以elisp语言与clojure语言为主
- emacs + elisp 成为 aiaos-cloel-rsi框架的前端
- clojure将实现自进化的aiaos框架，并在clojure侧持续地作为服务执行


## 项目设计目标

- 充分利用cloel架构的能力，将clojure框架（aiaos框架的clojure完全实现），构成emacs的高性能异步后端，将emacs彻底解放出来，emacs+elsip将成为轻量级同步响应式前端，而将所有的计算负载通过cloel网关，交由clojure服务器，进而由aiaos框架进行集中处理（充分利用多核、多进程、异步、与elisp语法相近的优势）。
- 

## 实现要求：

- emacs侧：elisp语言
- cloel侧：elisp，clojure
- clojure侧：clojure语言
- aiaos侧：clojure语言

## 项目基本设定

- 项目目录：~/.emacs.d/aiaos-cloel-rsi
- emacs前端：通过M-x aiaos-rsi，加载emacs侧前端UI(aiaos-rsi buffer），实现cloel侧、clojure侧、aiaos框架侧的管理、状态监控、通信、管理等功能
- 参考项目：
  - cloel项目：~/emacs.d/cloel (仅参考，不要修改其代码）
  - cloel-agent项目：~/emacs.d/cloel-agent （注，这是一个失败的项目，仅作为cleol的案例进行参考。）
  - aiaos-cli项目：~/aiaos/aiaos-cli/elisp/ （这是一个elisp实现的emacs aiaos cli,作为本项目的aiaos框架侧使用clojure进行移植与实现aiaos-cloel-rsi-agent的参考。(仅参考，不要修改其代码，可以移植到clojure）
  - aiaos框架：~/aiaos，此框架为非clojure实现，仅作为clojure实现aiaos框架侧的自进化架构的参考。(仅参考，不要修改其代码，可以移植到clojure）

## 补充 (此项由aiaos-cloel-rsi及aiaos-cli自行补充）

  
