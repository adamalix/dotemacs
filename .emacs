(message "started loading settings ...")

(column-number-mode)

(defun add-path (p)
  (add-to-list 'load-path (concat custom-basedir p)))

(setq custom-basedir (expand-file-name "~/.emacs.d/"))
(add-path custom-basedir)

;; Hide the toolbar and friends
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Settings Theme
(message "applying theme settings ...")
(load-theme 'wombat)

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

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

       (global-set-key [(meta return)] 'fullscreen)

       (defun switch-full-screen ()
         (interactive)
         (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))

       (global-set-key [(meta return)] 'switch-full-screen)))

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(if (eq system-type 'darwin)
    (global-set-key (kbd "M-RET") 'toggle-fullscreen))
(if (eq system-type 'darwin)
    (global-set-key (kbd "C-x n") 'switch-to-buffer))
(global-set-key (kbd "M-8") 'pop-tag-mark)
;; Cursor and Line
(message "applying cursor settings ...")
(setq-default cursor-type 'box)
(setq-default show-trailing-whitespace t)
(setq-default transient-mark-mode t)
(blink-cursor-mode 1)
(show-paren-mode 1)
(set-cursor-color "IndianRed")

;; Font Settings
(message "applying font settings ...")
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil
			:family "Inconsolata" :height 130)
  (set-default-font "Inconsolata-13"))

;; set tab width in java from emacs wiki

(add-hook 'java-mode-hook
          (lambda ()
            (setq-default c-basic-offset 4)))

;; Emacs Meta options for mac from emacs wiki
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

;; Time stamps in buffers
(display-time)

;; Set indentation in html to 4
;; thanks roderyc
(add-hook 'html-mode-hook
          (lambda ()
            (setq-default sgml-basic-offset 4)))

(setq package-archives
    (quote (("marmalade" .
            "http://marmalade-repo.org/packages/"))))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(require 'paredit)
(dolist (hook '(emacs-lisp-mode-hook
                lisp-mode-hook
                slime-repl-mode-hook))
  (add-hook hook 'enable-paredit-mode))

;; Paths
(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))

(if (eq system-type 'gnu/linux)
    (setenv "PATH" (concat "/home/adam/bin:" (getenv "PATH")))
  (setenv "PATH" (concat "/Users/adam/bin:" (getenv "PATH"))))



(put 'narrow-to-region 'disabled nil)

(setq make-backup-files t)
(setq version-control t)
; Save all backup file in this directory.
(setq backup-directory-alist
      (quote ((".*" . "~/backup/emacs_autosave/"))))
; otherwise it keeps asking
(setq kept-new-versions 30)
(setq delete-old-versions t)

;; start the server
(setq server-socket-dir (format "/tmp/emacs%d" (user-uid)))
(server-start)

;; Experimental ensime mode
;; Load the ensime lisp code...
;(if (eq system-type 'darwin)
;    (add-to-list 'load-path "~/.ensime/elisp/")
;    )
;(if (eq system-type 'darwin)
;    (require 'ensime))
;(if (eq system-type 'darwin)
;    (setenv "ENSIME_JVM_ARGS" "-Xms1G -Xmx2G -Dfile.encoding=UTF-8"))
;(if (eq system-type 'darwin)
;    (setenv  "SBT_OPTS" "-Xms1G -Xmx2G -XX:MaxPermSize=1024m -Dfile.encoding=UTF-8"))
;; we need to extend the exec-path so we can call scala / sbt in ensime
(setq exec-path (append exec-path (list "/usr/local/bin")))

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
;(if (eq system-type 'darwin)
;    (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))

;; Revert all open buffers
(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files."))

;; pretty lambda from nick
(global-set-key (kbd "C-c l")
                (lambda () (interactive) (insert "λ")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; vc-git-grep pimping
(require 'thingatpt)
(defun my-git-grep (pattern)
  (interactive (list (read-string "Search pattern: " (substring-no-properties (or (thing-at-point 'symbol) "")))))
  (vc-git-grep pattern "" (substring (shell-command-to-string "git rev-parse --show-toplevel") 0 -1)))
(if (eq system-type 'darwin)
    (global-set-key (kbd "C-c C-f") 'my-git-grep))

(require 'windmove)
(windmove-default-keybindings)
(projectile-global-mode)

(setq projectile-enable-caching t)
;(require 'flx-ido)
;(ido-mode 1)
;(ido-everywhere 1)
;(flx-ido-mode 1)
;(setq projectile-completion-system 'ido)

(add-to-list 'load-path "~/.emacs.d/soy-mode/")
(load "soy-mode")

;; multiple cursors

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-set-key (kbd "M-C-SPC") 'set-rectangular-region-anchor)

;; line numbers in margin
(global-linum-mode t)

;; git-gutter. will not work in tty!
(require 'git-gutter-fringe)
(global-git-gutter-mode t)

;; rename file and buffer
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(electric-pair-mode t)
