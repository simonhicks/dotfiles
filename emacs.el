;;; -*- lexical-binding: t -*-

;; set up required packages
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (not package-archive-contents)
    (package-refresh-contents))
 (defvar my-packages '(starter-kit starter-kit-lisp starter-kit-ruby
                       evil evil-leader evil-paredit evil-nerd-commenter
                       evil-numbers)
   "A list of packages to ensure are installed at launch.")
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; set up the path properly so that emacs can find executables
(defun set-exec-path-from-shell-PATH ()
   (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
     (setenv "PATH" path-from-shell)
     (setq exec-path (split-string path-from-shell path-separator))))
(when window-system (set-exec-path-from-shell-PATH))


;; sensible backup file policy
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))


;; basic interaction stuff
(evil-mode 1)
(global-linum-mode 1)
 

;; C-g as general purpose escape key sequence.
(defun my-esc (prompt)
  "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
  (cond
   ((or (evil-insert-state-p)
        (evil-normal-state-p)
        (evil-replace-state-p)
        (evil-visual-state-p)) [escape])
   (t (kbd "C-g"))))
(define-key key-translation-map (kbd "C-g") 'my-esc)
(define-key evil-operator-state-map (kbd "C-g") 'keyboard-quit)
(set-quit-char "C-g")


;; look and feel
(setq evil-default-cursor t)
(load-theme 'deeper-blue t)
(setq fill-column 120)
(set-frame-parameter (selected-frame) 'alpha '(94 94))
(add-hook 'window-setup-hook
          '(lambda () (set-cursor-color "white")))
(add-hook 'after-make-frame-functions
          '(lambda (f) (with-selected-frame f (set-cursor-color "white"))))


;; set up elscreen
(setq elscreen-prefix-key "\C-t")
(add-to-list 'load-path "~/.emacs.d/APEL/")
(load "elscreen" "ElScreen" t)
(define-key evil-normal-state-map (kbd "SPC t n") #'elscreen-create)
(define-key evil-normal-state-map (kbd "] t") #'elscreen-next)
(define-key evil-normal-state-map (kbd "[ t") #'elscreen-previous)


;; default indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)


;; hard wrap for text files
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; make keyboard scrolling more intuitive
(setq scroll-step 1)
;; make mouse scrolling more intuitive
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)


;; commenting and uncommenting
(define-key evil-normal-state-map (kbd "SPC SPC") #'evilnc-comment-or-uncomment-lines)
(define-key evil-visual-state-map (kbd "SPC SPC") #'evilnc-comment-or-uncomment-lines)


;; buffer navigation
(define-key evil-normal-state-map (kbd "C-b") #'buffer-menu)

;; emacs M-x
(define-key evil-normal-state-map (kbd "C-;") nil)
(define-key evil-motion-state-map (kbd "C-; u") 'universal-argument)
(define-key key-translation-map (kbd "C-; C-;") (kbd "M-x"))
(define-key evil-normal-state-map (kbd "C-; C-f") #'ido-find-file)


;; window navigation
(define-key evil-normal-state-map (kbd "SPC h") (kbd "C-w h"))
(define-key evil-normal-state-map (kbd "SPC j") (kbd "C-w j"))
(define-key evil-normal-state-map (kbd "SPC k") (kbd "C-w k"))
(define-key evil-normal-state-map (kbd "SPC l") (kbd "C-w l"))
(define-key evil-normal-state-map (kbd "SPC v h") (kbd "C-x 3"))
(define-key evil-normal-state-map (kbd "SPC v j") (kbd "C-x 2"))
(define-key evil-normal-state-map (kbd "SPC v k") (kbd "C-x 2"))
(define-key evil-normal-state-map (kbd "SPC v l") (kbd "C-x 3"))


;; tab/backtab for jump lists
(define-key evil-normal-state-map (kbd "<backtab>") (kbd "C-o"))


;; autocompletion with dabbrev-expand
(define-key evil-insert-state-map (kbd "C-SPC") #'dabbrev-expand)


;; file navigation
(define-key evil-normal-state-map (kbd "SPC u t") #'undo-tree-visualize)
(global-set-key (kbd "C-x C-f") #'ido-find-file)


;; make repls display proper ansi colors
(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; prevent scss compile on save... rails does it automatically anyway
(setq scss-compile-at-save nil)


;; clojure/nrepl stuff
(defun clojure-playground ()
  (interactive)
  (find-file "/tmp/*playground*")
  (clipboard-kill-region 1 (point-max))
  (clojure-mode)
  (push-mark)
  (goto-char (point-min))
  (insert ";; This buffer is for notes you don't want to save, and for Clojure evaluation.\n")
  (insert ";; Remember, you'll need an nREPL connection to evaluate code...\n\n"))
(defun evil-nrepl ()
  (evil-define-key 'insert nrepl-interaction-mode-map
    "\C-SPC" 'complete-symbol)

  (evil-define-key 'normal nrepl-interaction-mode-map
    "K"         'nrepl-doc
    "\C-]"      'nrepl-jump
    "\C-t"      'nrepl-jump-back
    "\C-n\C-r" 'nrepl-switch-to-repl-buffer
    "\C-n\C-f" 'nrepl-eval-buffer
    "\C-n\C-e" 'nrepl-eval-expression-at-point
    "\C-n\C-s" 'nrepl-src
    "\C-n\C-m" 'nrepl-macroexpand-all
    "\C-n1"    'nrepl-macroexpand-1
    "\C-n\C-p" 'clojure-playground))

(setq nrepl-hide-special-buffers t)
(setq nrepl-popup-stacktraces-in-repl t)
(setq nrepl-popup-stacktraces nil)

(add-hook 'nrepl-mode-hook 'evil-nrepl)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)


;; paredit stuff
(defvar electrify-return-match
  "[\]}\)]"
  "If this regexp matches the text after the cursor, do an \"electric\" return.")
(defun electrify-return-if-match (arg)
  "If the text after the cursor matches `electrify-return-match' then
open and indent an empty line between the cursor and the text.  Move the
cursor to the new line."
  (interactive "P")
  (let ((case-fold-search nil))
    (if (looking-at electrify-return-match)
      (save-excursion (newline-and-indent)))
    (newline arg)
    (indent-according-to-mode)))

(define-key evil-normal-state-map (kbd "C-p") nil)
(defmacro add-my-paredit-bindings-to (state)
  `(evil-define-key ,state paredit-mode-map
                    ;; paredit doublequote
                    "\C-p\'" 'paredit-doublequote

                    ;; paredit wrap bindings
                    "\C-pwb"  'paredit-wrap-round     ; (foo |bar baz) -> (foo (|bar) baz)
                    "\C-pw["  'paredit-wrap-square    ; (foo |bar baz) -> (foo [|bar] baz)
                    "\C-pw{"  'paredit-wrap-curly     ; (foo |bar baz) -> (foo {|bar} baz)
                    "\C-pw<"  'paredit-wrap-angle     ; (foo |bar baz) -> (foo <|bar> baz)
                    "\C-pw*"  (lambda (&optional arg) ; (foo |bar baz) -> (foo *|bar* baz)
                                (interactive)
                                (paredit-wrap-sexp arg ?* ?*))

                    ;; paredit splice bindings
                    "\C-psh" 'paredit-splice-sexp-killing-backward ; (foo (bar |baz) quux) -> (foo bar | quux)
                    "\C-psl" 'paredit-splice-sexp-killing-forward  ; (foo (bar |baz) quux) -> (foo |baz quux)
                    "\C-pss" 'paredit-splice-sexp                  ; (foo (bar |baz) quux) -> (foo bar |baz quux)

                    ;; paredit split/join
                    "\C-pj" 'paredit-split-sexp ; (foo (bar |baz) quux) -> (foo (bar) (|baz) quux)
                    "\C-pk" 'paredit-join-sexps ; (foo (bar) |(baz) quux) -> (foo (bar |baz) quux)

                    ;; paredit front slurpage/barfage
                    "\C-p\C-l" 'paredit-forward-slurp-sexp  ; (foo (bar |baz) quux) -> (foo (bar |baz quux))
                    "\C-p\C-h" 'paredit-forward-barf-sexp ; (foo (bar |baz) quux) -> (foo (bar) |baz quux)

                    ;; paredit barfage
                    "\C-pl" 'paredit-backward-barf-sexp    ; (foo (bar |baz) quux) -> (foo bar (|baz) quux)
                    "\C-ph" 'paredit-backward-slurp-sexp)) ; (foo (bar |baz) quux) -> ((foo bar |baz) quux)
(defun my-paredit-stuff ()
  (interactive)
  (rainbow-delimiters-mode t)

  (add-my-paredit-bindings-to 'insert)
  (add-my-paredit-bindings-to 'normal)

  (turn-on-eldoc-mode)
  (eldoc-add-command
    'paredit-backward-delete
    'paredit-close-round)

  (local-set-key (kbd "RET") 'electrify-return-if-match)
  (eldoc-add-command 'electrify-return-if-match)
  (show-paren-mode t))
(add-hook 'paredit-mode-hook 'my-paredit-stuff)


;; TODO this is needed to fix this issue https://github.com/senny/emacs-eclim/issues/95
;; hopefully the need will go away when the issue is resolved
(require 'cl)
;; eclim stuff
(require 'eclim)
(global-eclim-mode)
(require 'eclimd)
(setq eclimd-wait-for-process nil
      help-at-pt-display-when-idle t
      help-at-pt-timer-delay 0.1
      ac-delay 0.5)
(help-at-pt-set-timer)

(require 'company)
(require 'company-emacs-eclim)
(defun my-java-stuff ()
  (company-emacs-eclim-setup)
  (company-mode)
  (define-key company-active-map
    (kbd "C-j") 'company-select-next-or-abort
    (kbd "C-k") 'company-select-previous-or-abort)

  (evil-define-key 'insert java-mode-map
    (kbd "C-SPC") 'company-complete)
  
  (evil-define-key 'normal java-mode-map
    (kbd "C-]") 'eclim-java-find-declaration))
(add-hook 'java-mode-hook 'my-java-stuff)


;; org mode stuff
(defun my-org-mode-stuff ()
  (evil-define-key 'insert org-mode-map
    (kbd "C-<return>")  'org-meta-return)
  (evil-define-key 'normal org-mode-map
    (kbd "SPC SPC") 'org-todo
    (kbd "SPC c")   'org-ctrl-c-ctrl-c))
(setq org-startup-indented t)
(setq org-hide-leading-stars t)
(add-hook 'org-load-hook 'my-org-mode-stuff)


;; other bindings
(define-key evil-normal-state-map (kbd "<backspace>") #'switch-to-buffer)


;; changes saved by "customize-mode" are ugly... hide them in a different file
(load
  (setq custom-file
        (expand-file-name "custom.el" user-emacs-directory))
  'noerror)

;; sensible backup policy
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
