; Japanese Input experience
(set-language-environment "Japanese")

; UNICODE
(set-keyboard-coding-system 'utf-8)

; Force non-BOM-marking encoding
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

; BOM-marking encoding
;(set-terminal-coding-system 'utf-8-with-signature-dos)
;(set-buffer-file-coding-system 'utf-8-with-signature-dos)

; disable generating backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

; diable splash
(setq inhibit-splash-screen t)

; paren-mode
(show-paren-mode 1)
(setq show-paren-delay 0) ;; zero delay
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#898a84" :weight 'normal)

;; editor theme based on monokai
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#272822" :foreground "#eaeaea" :inverse-video nil :box nil :strike-through nil :verline nil :underline nil :slant normal :weight normal :height 132 :width normal))))
 '(font-lock-comment-face ((((class color)) (:foreground "#75715E"))))
 '(font-lock-function-name-face ((((class color)) (:foreground "#A6E22E"))))
 '(font-lock-keyword-face ((((class color)) (:foreground "#A6E22E"))))
 '(font-lock-preprocessor-face ((((class color)) (:foreground "#66D9Ef"))))
 '(font-lock-string-face ((((class color)) (:foreground "#E6DB74"))))
 '(font-lock-type-face ((((class color)) (:foreground "#66d9ef"))))
 '(font-lock-variable-name-face ((((class color)) (:foreground "#FD971F"))))
 '(region ((((class color)) (:background "#49483E"))))
 '(which-func ((((class color) (min-colors 88) (background dark)) (:foreground "#205f20")))))

; initial frame size
(setq initial-frame-alist
      (append  (list
                '(width . 120)
                '(height . 35)
                )
               initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

; transparent window
;(set-frame-parameter nil 'alpha 92 )

; show trailing spaces
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#373832")

; font settings
(set-face-attribute 'default nil :family "Inconsolata" )
(set-fontset-font
   (frame-parameter nil 'font)
  'japanese-jisx0208
  '("TakaoGothic" . "iso10646-1"))
(set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("TakaoGothic" . "iso10646-1"))
(setq face-font-rescale-alist '(("Takao.*" . 0.94)))

; window title to indicate the file name (makes it helpful for seeing at taskbar)
(setq frame-title-format "%b (%f)")

; CUA mode (C-c to copy, C-x to cut, C-v to paste, C-z to undo)
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Not to unselect after copying selection

; disable automatically-copying when a region is selected
(setq mouse-drag-copy-region nil)

; NEVER include tab character.
(setq-default indent-tabs-mode nil)

; C++ style
(add-hook 'c-mode-common-hook
          '(lambda()
             (c-set-style "stroustrup")
             (setq c-auto-newline nil)       ;
             (c-set-offset 'innamespace 0)   ;
             (c-set-offset 'arglist-close 0) ;
             ))

; tentative C++11 support
(add-hook
 'c++-mode-hook
 '(lambda()
    ;; We could place some regexes into `c-mode-common-hook', but note that their evaluation order
    ;; matters.
    (font-lock-add-keywords
     nil '(;; complete some fundamental keywords
           ("\\<\\(void\\|unsigned\\|signed\\|char\\|short\\|bool\\|int\\|long\\|float\\|double\\)\\>" . font-lock-keyword-face)
           ;; namespace names and tags - these are rendered as constants by cc-mode
           ("\\<\\(\\w+::\\)" . font-lock-function-name-face)
           ;;  new C++11 keywords
           ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
           ("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
           ;; PREPROCESSOR_CONSTANT, PREPROCESSORCONSTANT
           ("\\<[A-Z]*_[A-Z_]+\\>" . font-lock-constant-face)
           ("\\<[A-Z]\\{3,\\}\\>"  . font-lock-constant-face)
           ;; hexadecimal numbers
           ("\\<0[xX][0-9A-Fa-f]+\\>" . font-lock-constant-face)
           ;; integer/float/scientific numbers
           ("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>" . font-lock-constant-face)
           ;; c++11 string literals
           ;;       L"wide string"
           ;;       L"wide string with UNICODE codepoint: \u2018"
           ;;       u8"UTF-8 string", u"UTF-16 string", U"UTF-32 string"
           ("\\<\\([LuU8]+\\)\".*?\"" 1 font-lock-keyword-face)
           ;;       R"(user-defined literal)"
           ;;       R"( a "quot'd" string )"
           ;;       R"delimiter(The String Data" )delimiter"
           ;;       R"delimiter((a-z))delimiter" is equivalent to "(a-z)"
           ("\\(\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\)" 1 font-lock-keyword-face t) ; start delimiter
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\(.*?\\))[^\\s-\\\\()]\\{0,16\\}\"" 1 font-lock-string-face t)  ; actual string
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(.*?\\()[^\\s-\\\\()]\\{0,16\\}\"\\)" 1 font-lock-keyword-face t) ; end delimiter

           ;; user-defined types (rather project-specific)
           ("\\<[A-Za-z_]+[A-Za-z_0-9]*_\\(type\\|ptr\\)\\>" . font-lock-type-face)
           ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
           ))
    ) t)


; grep-mode override for Windows environment
; use findstr instead of grep since there is no grep command exists as default in Windows
(if (eq system-type 'windows-nt)
    (setq grep-command "findstr /spin ")
  (setq grep-use-null-device nil)) ; prevent adding "NUL" string on the tail
(defadvice grep (around grep-coding-setup activate) ; to allow Unicode for query string
  (let ((coding-system-for-read 'utf-8))
    ad-do-it))

; Jump command
(define-key global-map (kbd "C-j") 'goto-line)

; emacs server mode
(require 'server)
(unless (server-running-p)
  (server-start))

; package
(require 'cl)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)

;; install if not installed
(defvar my-packages
  '(auto-async-byte-compile
    auto-complete
    direx
    helm
    helm-ag
    helm-descbinds
    helm-ls-git
    init-loader
    js2-mode
    magit
    markdown-mode
    open-junk-file
    recentf-ext
    yasnippet))

(let ((not-installed
       (loop for package in my-packages
             when (not (package-installed-p package))
             collect package)))
  (when not-installed
    (package-refresh-contents)
    (dolist (package not-installed)
      (package-install package))))

;; init loader
(require 'init-loader)
(custom-set-variables
 '(init-loader-show-log-after-init nil))
(init-loader-load "~/.emacs.d/inits")

;; after init
(add-hook 'after-init-hook
  (lambda ()
    ;; split window
    ; (split-window-horizontally)
    ;; show init time
    (message "init time: %.3f sec"
             (float-time (time-subtract after-init-time before-init-time)))))

;; which-func-mode
(require 'which-func)
(add-to-list 'which-func-modes 'org-mode)
(which-func-mode 1)

; recentf settings
(require 'recentf)
(setq recentf-save-file "~/.emacs.d/cache/.recentf")
(setq recentf-max-saved-items 2000)
(setq recentf-exclude '(".recentf"))

; junk mode
(require 'open-junk-file)
(setq open-junk-file-format "~/Documents/junk_files/%Y-%m%d-%H%M%S.")
(global-set-key (kbd "C-x n") 'open-junk-file)

; magit
(require 'magit)
(if (eq system-type 'windows-nt)
    (setq magit-git-executable "C:/Program Files (x86)/Git/bin/git.exe"))

; helm
(require 'helm)

(progn
  (require 'helm-ls-git)
  (custom-set-variables
   '(helm-truncate-lines t)
   '(helm-buffer-max-length 35)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-ff-file-name-history-use-recentf t)
   '(helm-ff-auto-update-initial-value t)
   '(helm-ff-skip-boring-files t)
   '(helm-boring-file-regexp-list '("~$" "\\.elc$"))
   '(helm-ls-git-show-abs-or-relative 'relative)
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-ls-git
                                 helm-source-recentf
                                 helm-source-buffer-not-found))))
(progn
  (require 'helm-config)
  (global-unset-key (kbd "C-d"))
  (custom-set-variables
   '(helm-command-prefix-key "C-d")))

; ag for Windows (need for helm-ag)
;(setenv "PATH" (concat (getenv "PATH") ";C:\\Users\\yukiueno\\.emacs.d\\bin;"))

(global-set-key (kbd "C-;") 'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(define-key helm-command-map (kbd "d") 'helm-descbinds)
(define-key helm-command-map (kbd "g") 'helm-ag)
(define-key helm-command-map (kbd "o") 'helm-occur)
(define-key helm-command-map (kbd "M-/") 'helm-dabbrev)

; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

; redo+
(require 'redo+)
(define-key global-map (kbd "C-y")'redo)
(setq undo-no-redo t)
(setq undo-limit 100000)
(setq undo-strong-limit 1000000)
