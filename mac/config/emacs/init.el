;;; -*- lexical-binding: t -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wheatgrass))
 '(package-selected-packages
   '(alert all-the-icons dashboard rainbow-identifiers rust-mode
	   visual-fill-column)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-themed ((t (:background "blue1" :foreground "white")))))

(let ((default-directory "~/.nix-profile/share/emacs"))
  (normal-top-level-add-subdirs-to-load-path))

(setq-default indent-tabs-mode nil)

(setq blink-cursor-mode nil)
(setq cursor-type 'bar)

(setq recentf-max-saved-items 100)
(recentf-mode t)

(setq whitespace-style '(tab-mark))
(whitespace-mode)

(add-to-list 'backup-directory-alist '(("." . "~/.emacs.d/backups")))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'treesit-extra-load-path "~/.nix-profile/lib")
(add-to-list 'auto-save-file-name-transforms '(".*" "~/.emacs.d/auto-saves/" t))
(add-to-list 'lock-file-name-transforms '(".*" "~/.emacs.d/lock-files/" t))

(use-package vterm)

(use-package nix-ts-mode
  :mode "\\.nix\\'"
  :hook (nix-ts-mode . eglot-ensure))

(use-package rust-mode
  :hook (rust-mode . eglot-ensure)
  :init
  (setq rust-mode-treesitter-derive t))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) .
                 ("rust-analyzer" :initializationOptions
                  (:check (:command "clippy"))))))
