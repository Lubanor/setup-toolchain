;;; init.el --- Wangz Emacs configuration for Data Scientising
;; Optimized configuration for Python Programing, Data Exploration, and Document Processing.

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
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)  ; 此行为Windows添加
(setq locale-coding-system 'utf-8)    ; 此行为Windows添加
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; 性能优化
(setq gc-cons-threshold (* 1024 1024 20))
(setq read-process-output-max (* 1024 1024))

;; ===============================
;; 2. 包管理
;; ===============================
(require 'package)
(setq package-archives '(("gnu-tsinghua" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                        ("melpa-tsinghua" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;; 初始化use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
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
(set-fontset-font t 'han "SimSun-13")  ; 或 "Microsoft YaHei-13", "PingFang SC", "Noto Sans CJK SC"
(set-fontset-font t 'cjk-misc "SimSun-13")

(set-face-attribute 'mode-line nil :font "SimSun-13")

;; 主题设置
(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-icon t)
  (setq doom-modeline-unicode-fallback t)  ; Windows下使用Unicode字符
  :custom
  (doom-modeline-height 25))

(setq inhibit-compacting-font-caches t)
; M-x all-the-icons-install-fonts ; 第一次启动可能需要

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
(require 'evil) ; M-x evil-mode
(evil-mode 1) ; 启用 evil-mode

;; 补全框架
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-tooltip-align-annotations t
        company-show-quick-access t))

;; 语法检查
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

;; Jupyter支持
(use-package jupyter)

;; ===============================
;; 6. 文档写作
;; ===============================
;; Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; Org mode
(use-package org
  :config
  (setq org-startup-indented t
        org-startup-with-inline-images t))

;; LaTeX
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t
        TeX-engine 'xetex))

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

;; ===============================
;; 9. 结束配置
;; ===============================
(setq-default initial-scratch-message
              (concat ";; Happy Explorering in Emacs, "
                      (or user-login-name "") "!\n\n"))

(message "Emacs ready in %d seconds."
         (time-to-seconds (time-since emacs-start-time)))

(provide 'init)
;;; init.el ends here
