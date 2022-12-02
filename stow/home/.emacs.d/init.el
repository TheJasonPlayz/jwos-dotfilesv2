(global-auto-revert-mode 1)
(setq user-emacs-directory "~/.emacs.d/")
(setq user-init-file (expand-file-name "~/.emacs.d/init.el"))

(load-theme `wombat)

(set-face-attribute 'default nil :font "Source Code Pro" :height 110)

(scroll-bar-mode -1)
(tool-bar-mode -1)    
(tooltip-mode -1)       
(set-fringe-mode 10)

(setq inhibit-startup-message t)

(defun load-init ()
    (interactive)
  (find-file (expand-file-name "~/.emacs.d/init.el"))
  (eval-buffer))
(defun load-org-init ()
    (interactive)
  (find-file (expand-file-name "~/.emacs.d/init.org"))
  (org-babel-tangle))
(defun reload-emacs ()
  (interactive)
  (load-init-org)
  (load-init)
  (exwm-restart))
(defun reload-file ()
  (interactive)
  (find-file (expand-file-name (buffer-file-name))))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)	
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(use-package helpful
  :commands (helpful-callable helpful-command helpful-function helpful-key helpful-variable helpful-symbol)
  :bind 
  ([remap describe-key-briefly] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-function)
  ([remap describe-key] . helpful-key)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-symbol] . helpful-symbol)
  ([remap help-for-help] . helpful-at-point))

(use-package counsel)
(use-package eshell)
(use-package which-key)
(use-package magit)
(use-package rainbow-delimiters
  :config
  (rainbow-delimiters-mode 1))
(use-package haskell-mode)
(use-package lua-mode)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-M-<return>") 'eshell)
(global-unset-key (kbd "M-e"))
(global-set-key (kbd "M-e") 'eval-buffer)

(use-package exwm
:config

(defun jw/exwm-init-hook ()
  ())

;; Set number of workspaces
(setq exwm-workspace-number 5)

;; Rebind CapsLock to Super
(start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

;; Set resolution, position, and rotation
(require 'exwm-randr)
(exwm-randr-enable)
(start-process-shell-command "xrandr" nil "xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal")

;; Enable EXWM system tray.
(require 'exwm-systemtray)
(exwm-systemtray-enable)

;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
'(?\C-x
  ?\C-u
  ?\C-h
  ?\M-x
  ?\M-`
  ?\M-&
  ?\M-:
  ?\C-\M-j  ;; Buffer list
  ?\C-\ ))  ;; Ctrl+Space

 ;; Ctrl+Q will enable the next key to be sent directly
(define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

 (setq exwm-input-global-keys
    `(
      ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
      ([?\s-r] . exwm-reset)

      ;; Move between windows
      ([s-left] . windmove-left)
      ([s-right] . windmove-right)
      ([s-up] . windmove-up)
      ([s-down] . windmove-down)

      ([?\s-p] . (shell-command "rofi --show combi"))


      ;; Switch workspace
	([?\s-w] . exwm-workspace-switch)
	([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

	;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
	,@(mapcar (lambda (i)
		    `(,(kbd (format "s-%d" i)) .
		      (lambda ()
			(interactive)
			(exwm-workspace-switch-create ,i))))
		  (number-sequence 0 9))))

(exwm-enable))
