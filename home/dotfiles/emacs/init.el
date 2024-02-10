;; -*- lexical-binding: t -*-
(defvar evil-wins nil)
(defconst core-dir "~/.emacs.d")

(setq
 ;; debug-on-error t
 evil-wins nil
 docker-compose-command "docker compose"
 auto-window-vscroll nil
 backup-inhibited t
 compilation-ask-about-save nil
 compilation-scroll-output t
 completion-auto-help t
 create-lockfiles nil
 custom-file (expand-file-name "custom.el" user-emacs-directory)
 default-input-method "portuguese-prefix"
 dired-dwim-target t
 dired-listing-switches "-alFh"
 display-line-numbers-type 'relative
 eldoc-echo-area-use-multiline-p nil
 fast-but-imprecise-scrolling t
 indent-line-function 'insert-tab
 inhibit-startup-screen t
 initial-scratch-message nil
 make-backup-files nil
 next-line-add-newlines t
 ring-bell-function (lambda ())
 scroll-conservatively 10000
 shell-file-name "/run/current-system/sw/bin/bash"
 straight-use-package-by-default t
 disabled-command-function nil
 word-wrap t
 initial-major-mode #'text-mode
 auto-save-default nil
 inferior-lisp-program "sbcl")

(setq-default
 display-line-numbers-width 3
 straight-use-package-by-default t
 truncate-lines t
 word-wrap t
 indent-tabs-mode nil
 tab-width 2)

(add-hook
 'prog-mode-hook
 (lambda ()
   (interactive)
   (setq-local
    show-trailing-whitespace
    t)))

(windmove-default-keybindings)
(tool-bar-mode 0)
(menu-bar-mode 0)
;; (electric-pair-mode 1) ;; NOTE: Tá cagando o snippet de bloco de código do org-mode
(scroll-bar-mode 0)
(global-display-line-numbers-mode)
(savehist-mode 1)
(save-place-mode 1)
(auto-revert-mode)

(keymap-global-set "ć" (lambda () (interactive) (insert "ç")))
(keymap-global-set "C-S-<left>" 'shrink-window-horizontally)
(keymap-global-set "C-S-<right>" 'enlarge-window-horizontally)
(keymap-global-set "C-S-<down>" 'shrink-window)
(keymap-global-set "C-S-<up>" 'enlarge-window)
(keymap-global-set "C-c C-c" 'compile)
(keymap-global-set "C-c C-r" 'recompile)
(keymap-global-set "C-x b" 'consult-buffer)
(keymap-global-set
 "M->"
 (lambda ()
   (interactive)
   (if (string-equal
        (buffer-substring-no-properties
         (- (point-max) 1)
         (point-max))
        "\n")
       (goto-char (- (point-max) 1))
     (goto-char (point-max)))))

(load custom-file t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package benchmark-init
	:demand t
	:hook (after-init . benchmark-init/deactivate))

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package magit :defer t)
(use-package org
  :config
  (push 'org-tempo org-modules)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.5))
  :custom-face
  ;; (org-level-1 ((t (:height 180))))
  ;; (org-level-2 ((t (:height 160))))
  ;; (org-level-3 ((t (:height 140))))
  ;; (org-level-4 ((t (:height 120))))
  ;; (org-level-5 ((t (:height 100))))
  :custom
  (org-ellipsis "~"))

(add-hook 'org-mode-hook 'org-indent-mode)

(define-fringe-bitmap 'flyflyumpoucodemagomuitodeheroi (vector
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111
																												#b1111111))

(use-package flycheck
	:config
	(flycheck-redefine-standard-error-levels nil 'flyflyumpoucodemagomuitodeheroi)
	:custom
	(flycheck-display-errors-function nil))
(use-package counsel)
(use-package typescript-mode
	:mode "\\.ts\\'"
	:custom
	(typescript-indent-level 2))
(use-package ripgrep)
(use-package haskell-mode :mode "\\.hs\\'")
(use-package nix-mode :mode "\\.nix\\'")
(use-package nix-modeline :defer t)
(use-package typst-mode :mode "\\.typ\\'")
(use-package ob-typescript)
(use-package ob-restclient :straight (ob-restclient :type git :host github :repo "alf/ob-restclient.el"))
(use-package tuareg :mode ("\\.ml\\'" . tuareg-mode))
(use-package lua-mode :mode "\\.lua\\'")
(use-package docker)
(use-package docker-compose-mode)
(use-package dockerfile-mode)

(defun kill-other-buffers ()
	"Keep only the current buffer open, killing every other buffer."
	(interactive)
	(mapc
	 'kill-buffer
	 (remq (current-buffer)
				 (buffer-list))))
(defun org-roam-query ()
  "Query org-roam."
  (interactive)
  (let ((query-str (string-trim
                    (read-from-minibuffer
                     "Query: "))))
    (when (not (string-equal "" query-str))
      (org-ql-search
        (org-roam-list-files)
        (read query-str)))))
(defun org-roam-node-extract ()
	"Extracts region to node."
	(interactive)
	(progn
		(kill-region (point) (mark))
		(org-roam-node-find)
		(yank)))

(use-package
  org
  :custom (org-babel-load-languages
           '((haskell . t)
             (typescript . t)
             (lua . t)
             (restclient . t)
             (C . t)
             (ocaml . t)
             (ruby . t)))
  (org-agenda-files
   '("~notes/agenda.org"))
  (org-confirm-babel-evaluate
   nil)
  (org-hide-emphasis-markers t)
  (org-return-follows-link t)
  (org-src-tab-acts-natively t))

(use-package
  org-roam
  :config
  (org-roam-db-autosync-mode)
  (fmakunbound 'org-roam-dailies-find-today)
  (fmakunbound 'org-roam-dailies-find-yesterday)
  (fmakunbound 'org-roam-dailies-find-date)
  (fmakunbound 'org-roam-dailies-find-tomorrow)
  (fmakunbound 'org-roam-dailies-find-directory)
  (fmakunbound 'org-roam-dailies-find-next-note)
  (fmakunbound 'org-roam-dailies-find-previous-note)
  :custom (org-roam-directory
           (file-truename "~/notes"))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n q" . org-roam-query)
         ("C-c n d" . org-roam-dailies-capture-today)))

(use-package ox-gfm)

(use-package osm
	:after org
	:straight (osm :type git :host github :repo "minad/osm")
  :bind ("C-c m" . osm-prefix-map)
  :custom
  (osm-server 'default)
  (osm-copyright t)
  :init
  (require 'osm-ol))

(use-package vertico
	:custom
	(vertico-cycle t)
	(vertico-count 5)
  :init
  (vertico-mode 1))

(use-package consult)

(use-package embark
  :bind(("C-." . embark-act)
 	("C-;" . embark-dwim)
 	("C-h B" . embark-bindings))
  :config
  (add-to-list 'display-buffer-alist
 	       '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
 		 nil
 		 (window-parameters (mode-line-format . none)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
	(orderless-matching-styles '(orderless-literal orderless-regexp)) ;; orderless-flex
  (completion-styles '(orderless basic))
 	(completion-category-defaults nil)
 	(completion-category-overrides '((file (styles . (partial-completion))))))

(use-package corfu
  :init
  (global-corfu-mode 1)
  (setq corfu-popupinfo-delay 0.2)
  (corfu-popupinfo-mode)
  :straight (:files (:defaults "extensions/*"))
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.0)
  :bind
  (:map corfu-map
 	("TAB" . corfu-next)
 	([tab] . corfu-next)
 	("S-TAB" . corfu-previous)
 	([backtab] . corfu-previous)))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package doom-themes)

(defun org-insert-url-with-title (edit-url-p)
  "Insert URL with title."
  (interactive "P")
  (let* ((last-text-clipboard (gui-get-primary-selection))
         (url (if (string-match-p "https?://" last-text-clipboard) last-text-clipboard (read-string "URL: ")))
         (title (caddar
                 (dom-by-tag
                  (with-current-buffer
                      (url-retrieve-synchronously
                       url)
                    (libxml-parse-html-region))
                  'title))))
    (if edit-url-p
        (org-insert-link nil url (read-string "Title: " nil nil title))
      (if (boundp 'custom-org-insert-url-transformer)
          (org-insert-link nil url (funcall custom-org-insert-url-transformer (url-generic-parse-url url) title))
        (org-insert-link nil url title)))))

(use-package org-roam-ui :after org-roam)
(use-package rg)
(use-package sly)
(use-package elm-mode)

(use-package markdown-mode)
(use-package dune)

(use-package clang-format)
(use-package steam :custom (steam-username "molvr"))

;; (use-package doom-modeline
;; 	:config
;; 	(doom-modeline-mode)
;; 	:custom
;; 	(doom-modeline-buffer-file-name-style 'relative-to-project))

(use-package clojure-mode)
(use-package cider :custom (cider-repl-display-help-banner nil))
(use-package rust-mode)
(use-package lean4-mode
	:straight (lean4-mode
						 :type git
						 :host github
						 :repo "leanprover/lean4-mode"
						 :files ("*.el" "data"))
	:commands (lean4-mode))

(use-package ruby-mode)
(use-package parinfer)
(use-package restclient :config (use-package restclient-jq))
(use-package elixir-mode)
(use-package lispy
  :config
  (lispy-define-key lispy-mode-map "e" #'my/lispy-eval)
  (lispy-define-key lispy-mode-map "E" #'my/lispy-eval-and-insert)
  (push 'cider lispy-compat)
	:hook
	(emacs-lisp-mode . lispy-mode))

(use-package fennel-mode)
(use-package
	org-fragtog
	:hook (org-mode . org-fragtog-mode))

(setq org-format-latex-options
			'(:foreground default
										:background default
										:scale 1.5
										:html-foreground "Black"
										:html-background "Transparent"
										:html-scale 1.0
										:matchers ("begin"
															 "$1"
															 "$"
															 "$$"
															 "\\("
															 "\\[")))

(use-package vterm)
(use-package multiple-cursors
  :bind
  ("C-x m" . mc/edit-lines)
  :custom
  (mc/always-run-for-all t))
(use-package geiser-chez)

(defun copy-line ()
	"Kill current line."
	(interactive)
	(save-excursion
		(beginning-of-line)
		(set-mark-command nil)
		(end-of-line)
		(kill-ring-save
		 (region-beginning)
		 (region-end))))

(defun join-path (path filename)
	"Join PATH with FILENAME, adding a trailing slash in PATH if necessary."
	(concat path (if (string-match-p "/$" path) "" "/") filename))

(defun find-init-file ()
	"Find user init.el."
	(interactive)
	(when (not (string-equal
							(buffer-file-name)
							(file-truename user-init-file)))
		(find-file user-init-file)))

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'load-path (join-path core-dir "core"))

(use-package ace-window
	:bind
	("M-o" . ace-window))

(use-package flycheck-eglot)
(use-package devdocs)

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package quickrun)
(use-package org-ql)
(use-package
  svg-tag-mode
  :custom (svg-tag-tags
           '((":TODO:" . ((lambda (tag)
                            (svg-tag-make "TODO")))))))

(set-face-attribute 'link nil :underline nil)

(defun lang-fmt ()
  (interactive)
  (if (use-region-p)
      (eglot-format
       (region-beginning)
       (region-end))
    (eglot-format)))



(use-package projectile
	:config
	(projectile-mode 1)
  :bind
  ("C-x p f" . projectile-find-file)
  ("C-x p c" . projectile-compile-project)
  ("C-x p s" . projectile-switch-project)
	:custom
	(projectile-project-search-path '("~/projects/" "~/nixos" "~/playground")))

(use-package git-timemachine)

(use-package
	koka-mode
	:straight (koka-mode
						 :type git
						 :host github
						 :repo "koka-lang/koka"
						 :files ("support/emacs/koka-mode.el")))

(use-package xterm-color)

(advice-add 'compilation-filter :around (lambda (f proc string) (funcall f proc (xterm-color-filter string))))

(use-package direnv)
(use-package flycheck-projectile :after flycheck projectile)
(use-package kotlin-mode)
(use-package pueue :straight (pueue :type git :host github :repo "xFA25E/pueue"))
(use-package zig-mode)
(use-package unison-mode)
(use-package define-it)
(use-package rainbow-mode)
(use-package csv-mode)

(defun mtg-card ()
  "Query a Magic The Gathering card."
  (interactive)
  (let ((card (read-from-minibuffer "Card: ")))
    (with-current-buffer
        (url-retrieve
         (format
          "https://api.scryfall.com/cards/search?q=%s"
          (url-hexify-string card))
         (lambda (&rest ignore)
           (kill-paragraph 1)
           (kill-line)
           (let-alist
               (json-read-from-string
                (buffer-string))
             (message
              "%s"
              (cdr (assq 'name (aref \.data 0))))))
         nil
         'silent
         'inhibit-cookies))))

(defun color-hsl-to-hex (h s l)
  (let ((color (color-hsl-to-rgb
                (/ h 360.0)
                (/ s 100.0)
                (/ l 100.0))))
    (apply #'color-rgb-to-hex color)))

(defvar after-load-theme-hook nil
    "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks
   'after-load-theme-hook))

(defun customize-theme ()
  (interactive)
  (pcase
      (car custom-enabled-themes)
    ('doom-xcode
     (set-face-attribute
      'line-number-current-line
      nil
      :italic nil
      :foreground (color-hsl-to-hex 322 81 43)
      :background (color-hsl-to-hex 282 0 13))
     (set-face-attribute
      'line-number
      nil
      :italic nil
      :bold nil
      :foreground (color-hsl-to-hex 0 0 45)))))

(add-hook 'after-load-theme-hook #'customize-theme)
(load-theme 'doom-gruvbox t)

;; Patch broken Clojure eval
(defun my/lispy-eval (&optional arg)
  (interactive)
  (if (eq major-mode 'clojure-mode)
      (cider-eval-defun-at-point)
    (lispy-eval arg)))

(defun my/lispy-eval-and-insert ()
  (interactive)
  (if (eq major-mode 'clojure-mode)
      (cider-pprint-eval-defun-to-comment)
    (lispy-eval-and-insert)))

(cl-defgeneric json-get (obj path)
  (:documentation "Gets path from a json decoded object."))

(cl-defmethod json-get ((obj string) path)
  obj)

(cl-defmethod
  json-get
  ((obj vector) path)
  (cond ((listp path)
         (if (eq (cdr path) nil)
             (aref obj (car path))
           (json-get
            (aref obj (car path))
            (cdr path))))
        ((numberp path) (aref obj path))))

(cl-defmethod
  json-get
  ((obj sequence) path)
  (cond ((symbolp path)
         (cdr (assq path obj)))
        ((listp path)
         (if (eq (cdr path) nil)
             (cdr (assq (car path) obj))
           (json-get
            (cdr (assq (car path) obj))
            (cdr path))))))

(use-package google-translate)
(use-package racket-mode)

(require 'tetris)
(keymap-set tetris-mode-map "x" #'tetris-rotate-prev)
(keymap-set tetris-mode-map "z" #'tetris-rotate-next)

(use-package dart-mode)
(use-package lsp-bridge)

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(keymap-global-set "M-<up>" #'move-line-up)
(keymap-global-set "M-<down>" #'move-line-down)

(defun remove-auto-indent-from-text-mode ()
  (when (eq major-mode 'text-mode) (electric-indent-local-mode -1)))

(add-hook 'after-change-major-mode-hook #'remove-auto-indent-from-text-mode)

(setq custom-org-insert-url-transformer
      (lambda (url title)
        (pcase
            (url-host url)
          ("www.youtube.com" (replace-regexp-in-string " - Youtube" "" title))
          ("youtube.com" (replace-regexp-in-string " - Youtube" "" title))
          ("twitter.com" (replace-regexp-in-string " / X" "" title))
          (_ title))))

(add-hook
 'gud-mode-hook
 (lambda ()
   (interactive)
   (setq-local
    show-trailing-whitespace
    nil)) nil t)

(add-hook
 'compilation-mode-hook
 (lambda ()
   (interactive)
   (setq-local
    show-trailing-whitespace
    nil)) nil t)

(defun recenter-top ()
  (interactive)
  (let ((recenter-positions '(top)))
    (recenter-top-bottom)))

(keymap-global-set "C-t" #'recenter-top)

(when evil-wins (load (join-path core-dir "core/mat-evil.el")))

(use-package flycheck-mypy)
(use-package flycheck-inline)

(defun kiki (str)
  `(lambda () (interactive) (insert ,str)))

(define-minor-mode reverse-mode
  "Aaaaa"
  :lighter " 123"
  :keymap `(("1" . ,(kiki "!")) ("!" . ,(kiki "1"))
            ("2" . ,(kiki "@")) ("@" . ,(kiki "2"))
            ("3" . ,(kiki "#")) ("#" . ,(kiki "3"))
            ("4" . ,(kiki "$")) ("$" . ,(kiki "4"))
            ("5" . ,(kiki "%")) ("%" . ,(kiki "5"))
            ("6" . ,(kiki "^")) ("^" . ,(kiki "6"))
            ("7" . ,(kiki "&")) ("&" . ,(kiki "7"))
            ("8" . ,(kiki "*")) ("*" . ,(kiki "8"))
            ("9" . ,(kiki "(")) ("(" . ,(kiki "9"))
            ("0" . ,(kiki ")")) (")" . ,(kiki "0")))
  (keymap-set lispy-mode-map "(" nil)
  (keymap-set lispy-mode-map ")" nil))

(use-package flutter)

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(add-hook 'prog-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format nil t)))

(use-package utop)

(setq auto-mode-alist
      (append
       '(("\\.agda\\'" . agda2-mode)
         ("\\.lagda.md\\'" . agda2-mode))
       auto-mode-alist))

(use-package evil
  :custom
  (evil-auto-indent nil)
  (evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-surround :after evil
  :config (global-evil-surround-mode 1))

(add-hook 'after-change-major-mode-hook (lambda () (electric-indent-mode -1)))

(use-package prolog)
(use-package scala-mode)
