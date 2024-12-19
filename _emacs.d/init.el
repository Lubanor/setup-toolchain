;;; init.el --- Wangz Emacs configuration for Data Scientising
;;; Optimized for Python Programing, Data Exploration, and Document Processing.

;;; Code:
(message "Emacs initing")

;; ===============================
;; 1. 基础设置
;; ===============================
;; 系统检测
(setq *sys=cygwin* (eq system-type 'cygwin))
(setq *sys=win64*  (eq system-type 'windows-nt))
(setq *sys=macos*  (eq system-type 'darwin))
(setq *sys=linux*  (or (eq system-type 'gnu/linux) (eq system-type 'linux)))
(setq *sys=unix*   (or (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)))

;; 基础依赖
(if (< emacs-major-version 28) (error "Emacs 28 or higher is required"))
(require 'cl-lib)
(setq emacs-start-time (current-time))

;; 编码设置
;; (prefer-coding-system 'utf-8)
;; (set-language-environment "UTF-8")
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)  ; 此行为Windows添加
;; (setq locale-coding-system 'utf-8)    ; 此行为Windows添加
;; (setq coding-system-for-read 'utf-8)
;; (setq coding-system-for-write 'utf-8)
;; (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; local
(defun test-utf8-locale-p (v)
  "Return whether locale string V relates to a utf-8 locale."
  (and v (string-match "utf-8" v)))

(defun locale-is-utf8-p ()
  "Return t if the \"locale\" command or environment variables prefer utf-8."
  (or (test-utf8-locale-p (and (executable-find "locale") (shell-command-to-string "locale")))
      (test-utf8-locale-p (getenv "LC_ALL"))
      (test-utf8-locale-p (getenv "LC_CTYPE"))
      (test-utf8-locale-p (getenv "LANG"))))

(when (or window-system (locale-is-utf8-p))
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (unless *sys=win64* (set-selection-coding-system 'utf-8))
  (prefer-coding-system 'utf-8))

;; ===============================
;; 2. 包管理
;; ===============================
(require 'package)
(setq package-archives '(("gnu-tsinghua" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                        ("melpa-tsinghua" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; (setq package-archives '(("gnu" . "http://mirrors.163.com/elpa/gnu/")
;;                         ("melpa" . "https://melpa.org/packages/")
;;                         ("org" . "http://orgmode.org/elpa/")
;;                         ))
;;
;; (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)
;; (add-to-list 'package-archives '("milkbox" . "https://melpa.milkbox.net/packages/") t)

(package-initialize)

;; 初始化use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; ===============================
;; 3. UI设置
;; ===============================
;; 基础UI配置
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(setq visible-bell t)
(global-hl-line-mode t)
(global-display-line-numbers-mode)
(global-visual-line-mode t)

;; 字体设置
(set-face-attribute 'default nil :family "Fira Code" :height 130) ;Hack
(set-fontset-font t 'han "SimSun-13") ; 或 "Microsoft YaHei-13", "PingFang SC", "Noto Sans CJK SC"
(set-fontset-font t 'cjk-misc "SimSun-13")
(set-face-attribute 'mode-line nil :font "SimSun-13")

;; 主题设置
(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(setq inhibit-compacting-font-caches t) ; M-x list-pack... install all-the-icons-install-fonts ; 第一次启动或需
(setq visible-bell t)                          ; No beep when reporting errors

;; ===============================
;; 4. 编辑功能
;; ===============================
;; 基础编辑设置
(setq-default indent-tabs-mode nil
              tab-width 4)
(show-paren-mode t)
(delete-selection-mode t)
(global-auto-revert-mode t)

;; modal editing
;; Evil基础配置
(use-package evil
  :ensure t  ;; 确保安装evil包
  :init
  ;; 基础设置
  (setq evil-want-integration t)          ;; 允许与其他模式集成
  (setq evil-want-keybinding nil)         ;; 禁用默认键位绑定，使用evil-collection
  ;; (setq evil-respect-visual-line-mode t)  ;; 在换行时遵循视觉行

  :config
  (evil-mode 1)  ;; 启用evil模式

  ;; 搜索相关设置
  (setq evil-search-module 'evil-search)           ;; 使用evil的搜索模块
  (setq evil-ex-search-vim-style-regexp t)         ;; 使用vim风格的正则表达式

  ;; 光标样式设置
  (setq evil-default-state 'normal)                ;; 默认使用normal状态
  (setq evil-insert-state-cursor '(bar "green"))   ;; 插入模式下使用绿色竖线
  (setq evil-normal-state-cursor '(box "orange"))) ;; normal模式下使用橙色方块

;; Evil Collection - 为更多Emacs模式提供Evil支持
(use-package evil-collection
  :after evil
  :ensure t
  :custom (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))  ;; 初始化evil-collection

;; Evil Commentary - 快速注释功能
;; 用法：gc{motion} 注释/取消注释; gcc - 注释当前行
(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

;; Evil Matchit - 改进的配对跳转
;; % 可以在HTML标签、if-else等语法结构间跳转
(use-package evil-matchit
  :ensure t
  :config
  (global-evil-matchit-mode 1))

;; 持久性撤销
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree))

;; 补全框架
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-tooltip-align-annotations t
        company-show-quick-access t)
  (add-hook 'after-init-hook 'global-company-mode))

;; 语法检查; flymake/flyspell
(use-package flycheck
  :init (global-flycheck-mode))

;; 项目管理
(use-package projectile
  :config
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; ===============================
;; 5. 开发环境
;; ===============================
;; LSP支持
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook ((python-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-idle-delay 0.1
        lsp-print-performance t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'bottom))

;; Python环境
(use-package python-mode
  :hook (python-mode . (lambda ()
                        (require 'lsp-pyright)
                        (pyvenv-mode 1)))
  :custom
  (python-shell-interpreter "python3"))

;; Jupyter支持 ob-ipython
(use-package jupyter)

;; Clang
(setq c-default-style "linux")
(setq c-basic-offset 4)

;; GDB
(setq gdb-many-windows t)
(setq gdb-show-main t)

;; ===============================
;; 6. 文档写作
;; ===============================
;; Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; LaTeX
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t
        TeX-engine 'xetex))

;; Org mode
(use-package org
  :config
  (setq org-startup-folded 'show2levels) ;; 默认展开级别

  (setq org-startup-indented t
        org-startup-with-inline-images t)

  (setq org-todo-keywords ;; TODO状态序列
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "SOMEDAY(s)" "|" "DONE(d)" "CANCELLED(c)")))

  (setq org-todo-keyword-faces ;; TODO状态样式
        '(("TODO" . (:foreground "red" :weight bold))
          ("NEXT" . (:foreground "blue" :weight bold))
          ("WAITING" . (:foreground "orange" :weight bold))
          ("SOMEDAY" . (:foreground "purple" :weight bold))
          ("DONE" . (:foreground "forest green" :weight bold))
          ("CANCELLED" . (:foreground "gray" :weight bold)))))

;; Org mode 专用的 Evil 配置
(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; ===============================
;; 7. 工具增强
;; ===============================
;; 搜索增强
(use-package ivy
  :init (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

(use-package swiper
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

;; 文件树
(use-package treemacs
  :bind (("M-0" . treemacs-select-window)
         ("C-x t t" . treemacs)))

;; 版本控制
(use-package magit
  :bind ("C-x g" . magit-status))

;; ===============================
;; 8. 其他设置
;; ===============================
;; 备份设置
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; 最近文件
(use-package recentf
  :init (recentf-mode 1)
  :config
  (setq recentf-max-saved-items 100
        recentf-exclude '("/tmp/" "/ssh:"))
  :bind ("C-x C-r" . recentf-open-files))

;; save desktop
(use-package saveplace
  :config
  (save-place-mode 1)
  (desktop-save-mode t)
  (setq desktop-restore-frames nil)
  ;; save a bunch of variables to the desktop file:
  (setq desktop-globals-to-save
        (append '((extended-command-history . 128)
                  (file-name-history        . 128)
                  (grep-history             . 128)
                  (compile-history          . 128)
                  (minibuffer-history       . 128)
                  (query-replace-history    . 128)
                  (read-expression-history  . 128)
                  (regexp-history           . 128)
                  (regexp-search-ring       . 128)
                  (search-ring              . 128)
                  (comint-input-ring        . 128)
                  (shell-command-history    . 128)
                  desktop-missing-file-warning
                  register-alist
                 ))))

;; Time display
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

;;; Miscellaneous
(setq disabled-command-hook nil)               ; Allow all disabled commands
(setq undo-limit 100000)                       ; Increase number of undo
(defalias 'qrr 'query-replace-regexp)          ; Define an alias

;; 性能优化
(setq-default gc-cons-percentage 0.5)          ; Increase garbage-collection threshold
(setq gc-cons-threshold (* 1024 1024 20))
(setq read-process-output-max (* 1024 1024))

;; ===============================
;; 9. 结束配置
;; ===============================
;; https://www.emacswiki.org/emacs/LoadingLispFiles
;; define some extra custom files
(setq custom-el (expand-file-name "custom.el" user-emacs-directory))
(setq custom-org (expand-file-name "custom.org" user-emacs-directory))
(unless (file-exists-p custom-el) (write-region "" nil custom-el)) ; 如果该文件不存在, touch它
;
;; The extra customs will be autoloaded.
(when (file-exists-p custom-org) (org-babel-tangle-file custom-org))
(when (file-exists-p custom-el)  (load custom-el))

(setq-default initial-scratch-message
              (concat ";; Happy Explorering in Emacs, "
                      (or user-login-name "") "!\n\n"))

(message "Emacs ready in %d seconds."
         (time-to-seconds (time-since emacs-start-time)))

(provide 'init)
;;; init.el ends here
