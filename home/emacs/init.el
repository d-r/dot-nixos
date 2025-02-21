;;; -*- lexical-binding: t -*-

;; This config assumes Emacs 29 or later.
;;
;; Sources:
;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/

;;------------------------------------------------------------------------------
;; SANITY

;; Disable backups and lockfiles.
;; Stolen from https://protesilaos.com/emacs/dotemacs.
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Refresh buffer when the underlying file changes on disk.
(global-auto-revert-mode t)

;; Auto refresh Dired buffers.
(setq global-auto-revert-non-file-buffers t)

;; Always load newest byte code.
(setq load-prefer-newer t)

;; Sentences don't have two spaces after full stop.
(setq sentence-end-double-space nil)

;; Disable electric-indent-mode as it interferes with org-indent-mode.
(electric-indent-mode -1)

;; Disable global eldoc mode. The thing that shows documentation in the echo
;; area for whatever is under the cursor. Find it distracting and annoying.
;; Only want that info when I ask for it.
(global-eldoc-mode -1)

;; Make it so that newly typed text overwrites the current selection.
(delete-selection-mode 1)

;; Delete the whole line instead of just clearing it.
(setq kill-whole-line t)

;; Stop Emacs from beeping at me.
(setq ring-bell-function 'ignore)

;; Allow answering "Are you sure?" style prompts with just "y" or "n" instead of
;; having to type out "yes" or "no".
(setopt use-short-answers t)

;; On macOS, map Meta to to Option, and Super to Command.
;; Railwaycat Emacs, /the macOS port of Emacs/, has these flipped for some
;; strange reason.
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

;; Use ripgrep instead of grep for scraping files.
;; This should speed up Denote's backlink buffer creation.
;;
;; Disabled this, because now and then I would get an error message when calling
;; `denote-open-or-create`.
;; TODO: Figure out what the problem is.
;;
;; (setq xref-search-program 'ripgrep)

;;------------------------------------------------------------------------------
;; PACKAGE MANAGEMENT

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(require 'use-package)
(setq use-package-always-ensure t)

;;------------------------------------------------------------------------------
;; APPEARANCE

;; Show column number in the modeline.
(column-number-mode 1)

;; Turn the cursor from a block into a vertical bar.
(setq-default cursor-type 'bar)

;; Highligh the current line.
(global-hl-line-mode 1)

;; (use-package doom-themes
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   ;; (load-theme 'doom-dark+ t)
;;   ;; (load-theme 'doom-one t)
;;   ;; More vibrant version of doom-one
;;   (load-theme 'doom-vibrant t)
;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

;; Needs to run this to get icons to display properly:
;; M-x nerd-icons-install-fonts
(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package modus-themes
  :init
  ;; Remove borders from the modeline.
  (setq modus-themes-common-palette-overrides
	'((border-mode-line-active unspecified)
          (border-mode-line-inactive unspecified)))
  ;; Load the dark modus theme.
  (load-theme 'modus-vivendi t))

;;------------------------------------------------------------------------------
;; MINIBUFFER

;; Enable auto completion.
(use-package vertico
  :init (vertico-mode))

;; This shows completion canditates a transient popup in the centre of the
;; screen, rather than inside the minibuffer at the bottom.
(use-package vertico-posframe
  :init (vertico-posframe-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init (savehist-mode))

;; Enable fuzzy matching.
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Enable better search and navigation commands to replace the builtin ones.
(use-package consult)

;; Display the key bindings following your currently entered incomplete command
;; (a prefix) in a popup.
(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.3))

;; Enable rich annotations.
;; For example, this adds descriptions to functions listed by M-x.
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;;------------------------------------------------------------------------------
;; PROGRAMMING

;; Enable auto completion popup.
(use-package corfu
  :custom
  ;; Automatically bring up completion menu as you type.
  (corfu-auto t)
  :hook ((prog-mode . corfu-mode))
  :init (global-corfu-mode))

;; Keep things correctly indented at all times.
(use-package aggressive-indent
  :config
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

;; Been trying out smartparens, but when you type ', it inserts a *pair* of them.
;; Deeply annoying default behaviour for Elisp editing.
;; It's configurable, but I shouldn't have to "fix" broken defaults.
(use-package smartparens)

;; Enable paredit for Elisp.
(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode))

(use-package magit)

;;------------------------------------------------------------------------------
;; ORG

(use-package org
  :config
  (setq org-startup-indented t)
  (setq org-support-shift-select t))

;; Make weeks start on Monday instead of on Sunday.
(use-package calendar
  :config
  (setq calendar-week-start-day 1))

;;------------------------------------------------------------------------------
;; DENOTE

(use-package denote
  :init
  (setq denote-directory (expand-file-name "~/org/denote"))
  (setq denote-known-keywords '("howto" "project" "person" "draft"))
  (setq denote-backlinks-show-context t)
  (setq denote-sort-keywords nil)

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have a literal "[D]"
  ;; followed by the file's title. Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1)

  ;; JOURNAL

  (require 'denote-journal-extras)

  (setq denote-journal-extras-keyword "daily")
  (setq denote-journal-extras-title-format 'day-date-month-year)

  ;; Put journal entries in denote-directory
  (setq denote-journal-extras-directory nil)

  ;; Bring up calendar when calling functions with DATE prefix
  (setq denote-date-prompt-use-org-read-date t)

  ;; DIRED

  (setq denote-dired-directories (list denote-directory))

  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories))

(use-package consult-denote
  :after denote)

;;------------------------------------------------------------------------------
;; FUNCTIONS

(defun dan/open-config ()
  (interactive)
  (find-file "~/.config/emacs/init.el"))

(defun dan/open-secondary-config ()
  (interactive)
  (find-file "~/.config/emacs/early-init.el"))

(defun dan/comment ()
  (interactive)
  (if (region-active-p)
      (call-interactively #'comment-or-uncomment-region)
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

;;------------------------------------------------------------------------------
;; KEYBINDINGS

(use-package general)

(general-define-key "<escape>" #'keyboard-escape-quit)
