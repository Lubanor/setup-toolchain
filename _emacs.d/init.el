;;; init.el --- Wangz Emacs configuration for Data Scientising
;;; Optimized for Python Programing, Data Exploration, and Document Processing.

;;; Code:
(message ">>> Emacs initing")

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
(setq visible-bell t) ;; No beep when reporting errors

;; ===============================
;; 4. 编辑功能
;; ===============================
;; 基础编辑设置
(setq-default indent-tabs-mode nil
              tab-width 4)
(show-paren-mode t)
(delete-selection-mode t)
(global-auto-revert-mode t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5)
  (setq which-key-show-early-on-C-h t)
  (setq which-key-idle-secondary-delay 0.0))

;; modal editing
(use-package meow
  :ensure t
  :config
  ; (meow-setup) ; `(defun meow-setup () ...)`
  (unless (bound-and-true-p meow-global-mode)
    (meow-global-mode 1)))

;; 持久性撤销
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

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
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; ===============================
;; 5. 开发环境
;; ===============================
;; LSP支持
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (((python-mode c-mode) . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-idle-delay 0.1
        lsp-print-performance t))

(use-package lsp-ui
  :after (lsp-mode)
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
(message "NOTE: You can define your own custom.org/.el as a plugin to init.el")
(setq custom-el (expand-file-name "custom.el" user-emacs-directory))
(setq custom-org (expand-file-name "custom.org" user-emacs-directory))
(unless (file-exists-p custom-el) (write-region "" nil custom-el)) ; 如果该文件不存在, touch它

;; The extra customs will be autoloaded.
(when (file-exists-p custom-org) (org-babel-tangle-file custom-org))
(when (file-exists-p custom-el) (load custom-el))

(setq-default initial-scratch-message
              (concat ";; Happy Explorering in Emacs, "
                      (or user-login-name "") "!\n\n"))

(message "<<< Emacs ready in %d seconds."
         (time-to-seconds (time-since emacs-start-time)))

(provide 'init)
;;; init.el ends here
