(use-package evil
	:init
	(setq evil-want-keybinding nil)
	:config
	(evil-set-leader 'normal (kbd "SPC"))
	(evil-define-key 'normal 'global (kbd "<leader>i") 'find-init-file)
	(evil-define-key 'normal 'global (kbd "<leader>nf") 'org-roam-node-find)
	(evil-define-key 'normal 'global (kbd "<leader>pf") 'projectile-find-file)
	(evil-define-key 'normal 'global (kbd "<leader>p/") 'projectile-ripgrep)
	(evil-define-key 'normal 'global (kbd "<leader>ps") 'projectile-switch-project)
	(evil-define-key 'normal 'global (kbd "<leader>pc") 'projectile-compile-project)
	(evil-define-key 'normal 'global (kbd "<leader>p!") 'projectile-run-shell-command-in-root)
	(evil-define-key 'normal 'global (kbd "<leader>p&") 'projectile-run-async-shell-command-in-root)
	(evil-define-key 'normal 'global (kbd "<leader>pb") 'projectile-switch-to-buffer)
	(evil-define-key 'normal 'global (kbd "]d") 'flycheck-next-error)
	(evil-define-key 'normal 'global (kbd "[d") 'flycheck-previous-error)
	(evil-define-key 'normal 'global (kbd "<leader>g") 'magit)
	(evil-define-key 'normal 'global (kbd "<leader>lf") 'lang-fmt)
	(evil-define-key 'normal 'global (kbd "<leader>la") 'eglot-code-actions)
	(evil-define-key 'normal 'global (kbd "<leader>b") 'consult-buffer)
	(evil-define-key 'normal 'global (kbd "<leader>r") 'recompile)
	(evil-define-key 'normal 'global (kbd "<leader>c") 'compile)
	(evil-set-initial-state 'pueue-mode 'emacs)
	(evil-mode 1)
	:custom
	(evil-vsplit-window-right t)
	(evil-split-window-below t)
	(evil-undo-system 'undo-redo))

(use-package evil-collection
	:after evil
	:config
	(evil-collection-init))

(use-package evil-surround
	:after evil
	:config
	(global-evil-surround-mode 1))

(use-package
	evil-commentary
	:after evil
	:config (evil-commentary-mode))

(provide 'mat-evil)
