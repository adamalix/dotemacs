(message "started loading settings ...")

(setq custom-basedir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path custom-basedir)
(add-to-list 'load-path "/usr/local/plt/bin")
(add-to-list 'load-path "/usr/local/bin")

(defun add-path (p)
  (add-to-list 'load-path (concat custom-basedir p)))


;; Hide the toolbar and friends
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Settings Theme
(message "applying theme settings ...")
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-initialize)
(color-theme-dark-laptop)

(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; Shell Settings
(message "applying shell settings ...")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'comint-output-filter-functions
          'comint-strip-ctrl-m)

;; Smooth Scrolling
(message "applying scrolling settings ...")
(setq scroll-step 1
      scroll-conservatively 10000)

;; Fullscreen
(cond ((eq system-type 'gnu/linux)
       (defun fullscreen ()
         (interactive)
         (set-frame-parameter nil 'fullscreen
                              (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

       (global-set-key [f11] 'fullscreen)

       (defun switch-full-screen ()
         (interactive)
         (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))

       (global-set-key [f11] 'switch-full-screen)))


(global-set-key (kbd "M-RET") 'ns-toggle-fullscreen)

;; Cursor and Line
(message "applying cursor settings ...")
(setq-default cursor-type 'box)
(setq-default show-trailing-whitespace t)
(setq-default transient-mark-mode t)
(blink-cursor-mode 1)
(show-paren-mode 1)

;; Font Settings
(message "applying font settings ...")
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil
			:family "consolas" :height 130)
  (set-default-font "Consolas-13"))

;; set tab width in java from emacs wiki

(add-hook 'java-mode-hook
  (lambda ()
    (setq c-basic-offset 2)))

;; Emacs 23 Meta options for mac from emacs wiki
(if (eq system-type 'darwin)
    (setq mac-option-key-is-meta nil))
(if (eq system-type 'darwin)
    (setq mac-command-key-is-meta t))
(if (eq system-type 'darwin)
    (setq mac-command-modifier 'meta))
(if (eq system-type 'darwin)
    (setq mac-option-modifier nil))

;; Tramp mode
(setq tramp-default-method "ssh")
