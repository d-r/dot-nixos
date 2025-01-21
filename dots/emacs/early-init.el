;;; -*- lexical-binding: t -*-

;; Source:
;; https://git.sr.ht/~ashton314/emacs-bedrock/tree/main/item/early-init.el.

;; TODO: Document what this does.
(setq gc-cons-threshold 10000000)

;; Suppress annoying warnings.
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Prevent Emacs from dumping all manner of shit into the config directory.
(setq user-emacs-directory (expand-file-name "~/.cache/emacs"))

;; Make config changes made through the customize UI go into a separate file
;; so init.el won't have a (custom-set-variables ...) section shoved into it.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;; Don't snap frame size to char size grid. Allow pixel-wise resize.
(setq frame-resize-pixelwise t)

;; Don't resize the frame when the font size changes.
(setq frame-inhibit-implied-resize t)

;; Allow scrolling by pixel rather than by line.
(setq pixel-scroll-precision-mode t)

;; Disable UI cruft.
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Disable the welcome screen and dump me straight into the scratch buffer on
;; startup instead.
(setq inhibit-startup-screen t)

;; Set the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-13"))
