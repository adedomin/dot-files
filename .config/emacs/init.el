;;; init.el --- Config for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; CODE:
;; Fast Startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(defvar native-comp-deferred-compilation-deny-list '()
  "Hack to fix straight.el for now.")

(defvar native-comp-async-report-warnings-errors nil
  "I don't need some god awful window split to tell me how broke my software is.")


(defun init--getenv-or (env default)
  "Get the environment variable ENV or return a sensible DEFAULT."
  (let ((envres (getenv env)))
    (if envres
        envres
      default)))

;; make emacs more XDG by using DATA_HOME for packages
(defvar-local init--my-data-home
    (format "%s/emacs/"
            (init--getenv-or "XDG_DATA_HOME" "~/.local/share"))
  "Proper XDG Data Home path.")

;; XDG state home
(defvar-local init--my-state-home
    (format "%s/emacs/"
            (init--getenv-or "XDG_STATE_HOME"
                             (init--getenv-or "XDG_DATA_HOME" "~/.local/state")))
  "Proper XDG state path for system specific binaries.")

;; XDG cache home
(defvar-local init--my-cache-home
    (format "%s/emacs/"
            (init--getenv-or "XDG_CACHE_HOME" "~/.cache"))
  "Proper XDG cache path for temporaries.")

;; redefine user-emacs-directory so junk goes into XDG_DATA_HOME
(setq user-emacs-directory init--my-data-home)
;; (setq native-comp-eln-load-path ',(bound-and-true-p native-comp-eln-load-path))
;; (add-to-list 'native-comp-eln-load-path (concat init--my-data-home
;;                                         "eln-cache/"))

;; nil causes a file to be moved for backup and a new file
;; saves after first backup, however, are done in-place.
(setq backup-by-copying t)
;; make backups in cache home (xyz.txt~)
(setq backup-directory-alist
      ;; Where "." matches everything, cache home is the destination
      `((".*" . ,(concat init--my-cache-home
                         "backup/"))))
;; same for #files#
(add-hook 'after-init-hook
          #'(lambda () (make-directory
                        (concat init--my-cache-home "autosave/")
                        t)))
(setq auto-save-file-name-transforms
      `((".*" ,(concat init--my-cache-home
                       "autosave/")
         t)))
(setq delete-old-versions t)
;; Move auto-save-list to DATA_HOME (XDG)
(setq auto-save-list-file-prefix (concat init--my-cache-home
                                         ".save-"))

;; make Frame title always the name of the active buffer
(setq frame-title-format "%b")

;; START - emacs built-in modes and other emacs configs
;; show matching parens in emacs
(show-paren-mode 1)

;; save ex / M-x history
(setq-default savehist-file (concat init--my-data-home "history")) ; XDG compliance
(savehist-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; Disable literal tabs always
(setq-default indent-tabs-mode nil)
;; some source files *need* tabs
(setq-default tab-width 4)
(setq-default c-default-style "bsd"
              c-basic-ofifset 4)
;; END - emacs built-in modes and other emacs configs

;; START package manager stuff

;; START Bootstrap package manager
(defvar bootstrap-version)
(setq-default straight-base-dir (concat init--my-data-home))
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" init--my-data-home))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; END Bootstrap package manager

;; START use-package package configs and hooks

;; make sure use-package exists
(straight-use-package
 '(use-package
    :host github
    :repo "jwiegley/use-package"
    :branch "master"))

(require 'use-package)

;; Built-in Remote SSH, sudo, etc...
(use-package tramp
  :config
  (add-to-list 'tramp-remote-path "~/.nix-profile/bin")
  (add-to-list 'tramp-remote-path "~/.local/bin"))

(use-package display-line-numbers
  :custom (display-line-numbers-type 'relative)
  :custom-face
  (line-number ((nil (:background "#f7f7f7"))))
  :hook (prog-mode . display-line-numbers-mode))

;; Built-in
(use-package whitespace
  :hook (prog-mode . whitespace-mode)
  :custom-face
  (whitespace-space ((nil (:background "#f7f7f7"))))
  :config
  (setq whitespace-style '(face spaces tab-mark))
  ;; define space face
  ;;visualize leading and/or trailing SPACEs.
  (setq whitespace-space-regexp  "\\(^ +\\| +$\\)"))

(use-package tab-line
  :after (evil)
  :bind (:map evil-normal-state-map
              ("<leader>a" . #'tab-line-switch-to-prev-tab)
              ("<leader>s" . #'tab-line-switch-to-next-tab))
  :config
  (global-tab-line-mode 1))

(use-package xref
  :after (evil)
  :bind (:map evil-normal-state-map
              ;; ("<leader>," . #'xref-pop-marker-stack)
              ("<leader>m" . #'xref-go-back)
              ("<leader>," . #'xref-go-forward)
              ("<leader>." . #'xref-find-definitions)
              ("<leader>/" . #'xref-find-references))
  :config
  (evil-define-key 'normal xref--xref-buffer-mode-map
    (kbd "TAB") #'xref-quit-and-goto-xref
    (kbd "RET") #'xref-goto-xref))

(use-package ediff
  :disabled
  :custom
  (ediff-split-window-function #'split-window-vertically)
  (ediff-merge-split-window-function #'split-window-vertically))

;; undo tree for evil mode's undo/redo
(use-package undo-tree
  :straight (undo-tree :host gitlab
                       :repo "tsc25/undo-tree")
  :custom (undo-tree-history-directory-alist backup-directory-alist)
  :config (global-undo-tree-mode))

(use-package evil-cleverparens
  :disabled
  :after (evil)
  :straight (evil-cleverparens)
  :hook (emacs-lisp-mode . evil-cleverparens-mode)
  :hook (lisp-mode . evil-cleverparens-mode)
  :hook (lisp-interaction-mode . evil-cleverparens-mode)
  :hook (racket-mode . evil-cleverparens-mode)
  :hook (scheme-mode . evil-cleverparens-mode))

(use-package rainbow-delimiters
  :straight (rainbow-delimiters)
  :hook (emacs-lisp-mode . rainbow-delimiters-mode)
  :hook (lisp-mode . rainbow-delimiters-mode)
  :hook (lisp-interaction-mode . rainbow-delimiters-mode)
  :hook (racket-mode . rainbow-delimiters-mode)
  :hook (scheme-mode . rainbow-delimiters-mode))

(use-package treemacs
  :straight (treemacs :host github
                      :repo "Alexander-Miller/treemacs")
  :after (evil)
  :commands treemacs
  :bind (:map evil-normal-state-map
              ("<leader>q" . treemacs))
  :config
  (evil-define-state treemacs
    "Treemacs state"
    :cursor '(bar . 0)
    :enable (motion))

  (evil-set-initial-state 'treemacs-mode 'treemacs)

  (define-key evil-treemacs-state-map (kbd "k")   #'treemacs-next-line)
  (define-key evil-treemacs-state-map (kbd "l")   #'treemacs-previous-line)
  (define-key evil-treemacs-state-map (kbd "M-k") #'treemacs-next-neighbour)
  (define-key evil-treemacs-state-map (kbd "M-l") #'treemacs-previous-neighbour)
  (define-key evil-treemacs-state-map (kbd "M-K") #'treemacs-next-line-other-window)
  (define-key evil-treemacs-state-map (kbd "M-L") #'treemacs-previous-line-other-window)
  (define-key evil-treemacs-state-map (kbd "th")  #'treemacs-toggle-show-dotfiles)
  (define-key evil-treemacs-state-map (kbd "tw")  #'treemacs-toggle-fixed-width)
  (define-key evil-treemacs-state-map (kbd "tv")  #'treemacs-fringe-indicator-mode)
  (define-key evil-treemacs-state-map (kbd "tf")  #'treemacs-follow-mode)
  (define-key evil-treemacs-state-map (kbd "ta")  #'treemacs-filewatch-mode)
  (define-key evil-treemacs-state-map (kbd "tg")  #'treemacs-git-mode)
  (define-key evil-treemacs-state-map (kbd "w")   #'treemacs-set-width)
  (define-key evil-treemacs-state-map (kbd "b")   #'treemacs-add-bookmark)
  (define-key evil-treemacs-state-map (kbd "?")   #'treemacs-common-helpful-hydra)
  (define-key evil-treemacs-state-map (kbd "C-?") #'treemacs-advanced-helpful-hydra)
  (define-key evil-treemacs-state-map (kbd "RET") #'treemacs-RET-action)
  (define-key evil-treemacs-state-map (kbd "TAB") #'treemacs-TAB-action)
  (define-key evil-treemacs-state-map (kbd "J")   #'treemacs-collapse-parent-node)
  (define-key evil-treemacs-state-map (kbd "!")   #'treemacs-run-shell-command-for-current-node)
  (define-key evil-treemacs-state-map (kbd "pr")  #'treemacs-remove-project-from-workspace)
  (define-key evil-treemacs-state-map (kbd "pa")  #'treemacs-add-project)

  (evil-define-key 'treemacs treemacs-mode-map
    (kbd "yp")     #'treemacs-copy-project-path-at-point
    (kbd "ya")     #'treemacs-copy-absolute-path-at-point
    (kbd "yr")     #'treemacs-copy-relative-path-at-point
    (kbd "yf")     #'treemacs-copy-file
    (kbd "gr")     #'treemacs-refresh
    [down-mouse-1] #'treemacs-leftclick-action
    [drag-mouse-1] #'treemacs-dragleftclick-action
    (kbd "j")      #'treemacs-root-up
    (kbd ";")      #'treemacs-root-down))

(use-package lsp-treemacs
  :straight (lsp-treemacs :host github
                          :repo "emacs-lsp/lsp-treemacs")
  :after (treemacs lsp-mode)
  :hook (lsp-mode . (lambda () (lsp-treemacs-sync-mode 1)))
  :config
  (evil-define-key 'normal lsp-mode-map
    (kbd "<leader>ts")   #'lsp-treemacs-symbols
    (kbd "<leader>te")   #'lsp-treemacs-errors-list))

(use-package lorem-ipsum
  :straight (lorem-ipsum :host github
                         :repo "jschaf/emacs-lorem-ipsum")
  :commands lorem-ipsum-insert-list
  :commands lorem-ipsum-insert-paragraphs
  :commands lorem-ipsum-insert-sentences)

(defvar init--font-list '("Droid Sans Mono 11" "Noto Mono 11" "DejaVu Sans Mono 11" "Courier New 11" "monospace 11")
  "List of Fonts to try to use.")

(defun init--set-font ()
  "Set the frame font."
  (seq-find
   (lambda (font)
     (condition-case nil
         (progn
           (set-frame-font font nil nil)
           t)
       (error nil)))
     init--font-list))

(use-package twilight-bright-theme
  :straight (twilight-bright-theme :host github
                                   :repo "jimeh/twilight-bright-theme.el")
  :if (display-graphic-p)
  :config
  (init--set-font)
  (load-theme 'twilight-bright t))

(unless (display-graphic-p)
  (add-to-list 'term-file-aliases
               '("foot" . "xterm-256color"))
  (setq frame-background-mode 'light)
  (xterm-mouse-mode))

;; Macro that throws license snippets into the heading of your code
;; evil-ex -> :lice
;; emacs   -> M-x lice
(use-package lice
  :straight (lice :host github
                  :repo "buzztaiki/lice-el")
  :custom
  (lice:default-license "mit")
  (lice:copyright-holder "Anthony DeDominic <adedomin@gmail.com>")
  :commands lice)

(use-package magit
  :straight (magit :host github
                   :repo "magit/magit")
  :commands magit)

(use-package tree-sitter
  :disabled
  :straight (tree-sitter)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :hook (rust-mode . tree-sitter-mode)
  :hook (go-mode . tree-sitter-mode)
  :hook (sh-mode . tree-sitter-mode)
  :hook (c-mode . tree-sitter-mode)
  :hook (c++-mode . tree-sitter-mode)
  :hook (html-mode . tree-sitter-mode)
  :hook (python-mode . tree-sitter-mode)
  :hook (typescript-mode . tree-sitter-mode)
  :hook (javascript-mode . tree-sitter-mode)
  :hook (json-mode . tree-sitter-mode)
  :hook (js-mode . tree-sitter-mode))

(use-package tree-sitter-langs
  :disabled
  :straight (tree-sitter-langs)
  :after tree-sitter)

(use-package tree-edit
  :disabled
  :straight (tree-edit :host github
                       :repo "ethan-leba/tree-edit")
  :hook (tree-sitter-after-on . evil-tree-edit))

(use-package yasnippet
  :straight (yasnippet :host github
                       :repo "joaotavora/yasnippet"))

(defun init--bash-lsp-setup ()
  "Setup bash-lsp to use shellcheck."
  (eglot-ensure)
  (add-hook 'lsp-after-initialize-hook
            (flycheck-add-next-checker
             'lsp
             '(warning . 'sh-shellcheck)
             'append)))

(defvar init--eglot-keymap (make-sparse-keymap)
  "Define an empty eglot keymap.")

(use-package eglot
  ;; :after evil
  :hook (python-mode . eglot-ensure)
  :hook (go-mode . eglot-ensure)
  :hook (c-mode . eglot-ensure)
  :hook (c++-mode . eglot-ensure)
  :hook (rust-mode . eglot-ensure)
  ;;:hook (sh-mode . init--bash-lsp-setup)
  ;; :hook (eglot-ensure-mode . lsp-enable-which-key-integration)
  :hook (nix-mode . eglot-ensure)
  :hook (js-mode . eglot-ensure)
  :hook (zig-mode . eglot-ensure)
  :hook (haskell-mode . eglot-ensure)
  :hook (tuareg-mode . eglot-ensure)
  :hook (racket-mode . eglot-ensure)
  :commands eglot-ensure
  :bind (:map init--eglot-keymap
              ("h" . #'eldoc)
              ("c" . #'eglot-code-actions)
              ("fb" . #'eglot-format-buffer)
              ("fr" . #'eglot-format))
  :bind-keymap ("<leader>e" . init--eglot-keymap)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil"))))

;; Activated by lsp-mode
(use-package lsp-ui
  :disabled
  :after evil ;; evil-define-key
  :straight (lsp-ui :host github
                    :repo "emacs-lsp/lsp-ui")
  :commands lsp-ui-mode
  :config
  ;;(setq init--local-lsp-ui-doc-toggle nil)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-position 'at-point)
  (evil-define-key 'normal lsp-mode-map
    (kbd "<leader>SPC") #'lsp-ui-doc-glance))

(use-package lsp-mode
  :disabled
  :straight (lsp-mode :flavor melpa
                      :host github
                      :repo "emacs-lsp/lsp-mode")
  :after evil
  :hook (python-mode . lsp)
  :hook (go-mode . lsp)
  :hook (c-mode . lsp)
  :hook (c++-mode . lsp)
  :hook (rust-mode . lsp)
  ;;:hook (sh-mode . init--bash-lsp-setup)
  :hook (lsp-mode . lsp-enable-which-key-integration)
  :hook (js-mode . lsp)
  :hook (zig-mode . lsp)
  :hook (haskell-mode . lsp)
  :hook (tuareg-mode . lsp)
  :hook (racket-mode . lsp)
  :commands lsp
  :custom
  ;;(lsp-enable-indentation nil)
  (lsp-prefer-capf t)
  (lsp-auto-guess-root t)
  (lsp-keep-workspace-alive nil)
  (lsp-clients-clangd-args '("--header-insertion=never"))
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-eldoc-render-all nil)
  :bind (:map evil-normal-state-map
              ("<leader>h" . #'lsp-describe-thing-at-point)
              ("<leader>cof" . #'lsp-clangd-find-other-file))
  :bind-keymap ("<leader>e" . lsp-command-map)
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection
                                     "clangd")
                    :activation-fn (lsp-activate-on "c" "cpp" "objective-c")
                    :server-id 'clangd-remote
                    :priority -1
                    :library-folders-fn (lambda (_workspace) lsp-clients-clangd-library-directories)
                    :remote? t))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection (lambda ()
                                                            '("racket" "--lib" "racket-langserver")))
                    :major-modes '(racket-mode)
                    :priority 1
                    :server-id 'racket-langserver)))

(use-package lsp-haskell
  :disabled
  :after haskell-mode
  :straight (lsp-haskell :host github
                         :repo "emacs-lsp/lsp-haskell"))

(use-package cmake-project
  :disabled
  :straight (cmake-project)
  :commands cmake-project-mode)

(use-package flymake
  :hook (emacs-lisp-mode . flymake-mode)
  :bind (:map evil-normal-state-map
              ("[d" . #'flymake-goto-prev-error)
              ("]d" . #'flymake-goto-next-error)))

;; Slightly better automagic linting runner
(use-package flycheck
  :disabled
  :straight (flycheck :host github
                      :repo "flycheck/flycheck")
  :hook (sh-mode . flycheck-mode)
  :hook (go-mode . flycheck-mode)
  :hook (python-mode . flycheck-mode)
  :hook (c-mode . flycheck-mode)
  :hook (c++-mode . flycheck-mode)
  :hook (emacs-lisp-mode . flycheck-mode)
  :hook (js-mode . flycheck-mode)
  :hook (typescript-mode . flycheck-mode)
  :hook (rust-mode . flycheck-mode)
  :hook (nix-mode . flycheck-mode))

;; Provides combobox like lists for autocomplete choices
(use-package company
  :straight (company :host github
                     :repo "company-mode/company-mode")
  :custom
  (company-dabbrev-downcase nil)
  (company-idle-delay 0)
  (company-minimum-prefix-length 1)
  :hook (prog-mode . company-mode))

(use-package which-key
  :straight (which-key :host github
                       :repo "justbur/emacs-which-key")
  :config (which-key-mode))

;; BEGIN extra modes
(use-package go-mode
  :straight (go-mode :host github
                     :repo "dominikh/go-mode.el")
  :hook (before-save . gofmt-before-save)
  :mode "\\.go\\'")

(use-package typescript-mode
  :straight (typescript-mode :host github
                             :flavor melpa
                             :repo "emacs-typescript/typescript.el")
  :mode "\\.ts\\'")

(use-package rust-mode
  :straight (rust-mode)
  :custom
  (rust-format-on-save t)
  (rust-format-goto-problem nil)
  (rust-format-show-buffer nil)
  :mode "\\.rs\\'")

(use-package zig-mode
  :disabled
  :straight (zig-mode :host github
                      :repo "ziglang/zig-mode")
  :mode "\\.zig\\'")

(use-package nix-mode
  :straight (nix-mode :host github
                      :repo "NixOS/nix-mode")
  :mode "\\.nix\\'")

(use-package haskell-mode
  :disabled
  :straight (haskell-mode :host github
                          :repo "haskell/haskell-mode")
  :mode "\\.hs\\'")

(use-package purescript-mode
  :disabled
  :straight (purescript-mode :host github
                             :repo "purescript-emacs/purescript-mode")
  :custom (purescript-mode-hook 'purescript-indentation-mode)
  :mode "\\.purs\\'")

(use-package tuareg
  :disabled
  :straight (tuareg :host github
                    :repo "ocaml/tuareg")
  :hook (tuareg-mode . (lambda () (setq mode-name "🐫")))
  :mode ("\\.mli?\\'" . tuareg-mode))

(use-package racket-mode
  :disabled
  :straight  (racket-mode :host github
                          :repo "greghendershott/racket-mode")
  :mode ("\\.rktd?\\'" . racket-mode))

(use-package poke-mode
  :straight (poke-mode)
  :mode ("\\.pk\\'" . poke-mode))

(use-package poke
  :straight (poke)
  :config
  (setq poked-socket (concat
                      (init--getenv-or "XDG_RUNTIME_DIR" (concat "HOME" "~/.local/tmp"))
                      "/poked.ipc"))
  (defun poke-poked ()
    "Start the poke daemon.  The new process is associated with the
buffer `*poked*'."
    (interactive)
    (when (not (process-live-p poke-poked-process))
      (setq poke-poked-process
            (make-process :name "poked"
                          :buffer "*poked*"
                          :command (list poke-poked-program "--socket" poked-socket "--debug")))
      (set-process-query-on-exit-flag poke-poked-process nil))))

(use-package clojure-mode
  :disabled
  :straight (clojure-mode)
  :mode ("\\.clj\\'" . clojure-mode))
(use-package cider
  :disabled
  :hook (clojure-mode . cider-mode)
  :straight (cider))
;; END extra modes

(defun init--move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun init--move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(use-package eldoc-box
  :disabled
  :straight (eldoc-box)
  :hook (prog-mode . eldoc-box-hover-at-point-mode))

;; Vi in Emacs
(use-package evil
  :straight (evil :host github
                  :repo "emacs-evil/evil")
  :requires undo-tree
  :custom
  ;; evil-collection fixups depend on these being set
  (evil-want-keybinding nil)
  (evil-want-integration t)
  (evil-undo-system 'undo-tree)
  ;; ex commands will operate on visual selection, when applicable
  (evil-ex-visual-char-range t)

  :bind (:map evil-normal-state-map
              ("j" . #'evil-backward-char)
              ("k" . #'evil-next-line)
              ("l" . #'evil-previous-line)
              (";" . #'evil-forward-char)
              ("K" . #'evil-scroll-down)
              ("L" . #'evil-scroll-up)
              ;; other remaps
              ("q" . #'evil-redo)
              ;; restore emacs reverse search
              ("C-r" . nil)
              ;; Transpositions
              ("<leader><up>"   . #'init--move-line-up)
              ("<leader><down>" . #'init--move-line-down)
              ;; quit, no save
              ("ZX" . #'kill-this-buffer)
              ;; split (window) bindings
              ("<leader>TAB" . #'other-window)
              ("<leader>\\"  . ":vsplit")
              ("<leader>-"   . ":split")
              ("<leader>f"   . ":only")
              ("<leader>d"   . ":close")
              ("<leader>x"   . ":bdelete")
              ("M-<right>"   . #'enlarge-window-horizontally)
              ("M-<left>"    . #'shrink-window-horizontally)
              ("M-<down>"    . #'enlarge-window)
              ("M-<up>"      . #'shrink-window)
              ("<leader>j"   . #'evil-window-left)
              ("<leader>k"   . #'evil-window-down)
              ("<leader>l"   . #'evil-window-up)
              ("<leader>;"   . #'evil-window-right))
  
  :bind (:map evil-visual-state-map
              ("j" . #'evil-backward-char)
              ("k" . #'evil-next-line)
              ("l" . #'evil-previous-line)
              (";" . #'evil-forward-char)
              ("K" . #'evil-scroll-down)
              ("L" . #'evil-scroll-up))
  
  :config
  (evil-mode 1)
  ;; Leader
  (evil-set-leader 'normal (kbd "SPC")))

(use-package evil-collection
  :after (evil)
  :straight (evil-collection :host github
                             :repo "emacs-evil/evil-collection")
  ;;:custom
  ;; (evil-collection-use-company-tng nil)
  :config
  (evil-collection-init))

(use-package gcmh
  :straight (gcmh :host github
                  :repo "emacsmirror/gcmh")
  :config
  (setq gcmh-low-cons-threshold (expt 2 27))  ; 128MiB
  (setq gcmh-high-cons-threshold (expt 2 32)) ; 4GiB (this may need specific tuning.)
  (setq gcmh-idle-delay 30)
  (gcmh-mode 1))
;; END use-package package configs and hooks

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'init)
;;; init.el ends here
