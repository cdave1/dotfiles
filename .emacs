(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(jde-jdk-registry (quote (("1.6.0.20" . "/usr/share/jdk1.6.0_20")))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))


;; scala stuff
;; 
;; scala-mode provides scala syntax highlighting.

(add-to-list 'load-path "/home/david/emacs/modes/scala-mode")
(require 'scala-mode-auto)

;; yasnippets disabled due to a startup error that I need to
;; get around to fixing.
;;
;;(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
;;(require 'yasnippet) ;; not yasnippet-bundle
;;(yas/initialize)
;;(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")
;;
;;(add-hook 'scala-mode-hook
;;          '(lambda ()
;;            (yas/minor-mode-on)))
;;
;; (setq yas/my-directory "~/.emacs.d/modes/scala-mode/contrib/yasnippet/snippets")
;; (yas/load-directory yas/my-directory)


;; jrockway's eproject
;;
;; Allows us to setup projects in emacs with a few simple rules.
;; My primary goal with this is  to get around the fucked up 
;; project structure imposed by maven, so it's easier for me to load 
;; individual files in liftweb projects from within emacs.

(add-to-list 'load-path "~/emacs/eproject")
(require 'eproject)
(require 'eproject-extras)

;; Project files for scala liftweb projects
(define-project-type liftweb (generic) (look-for "pom.xml"))


;; window-number
;;
;; For easier window modification

(add-to-list 'load-path "~/emacs/window-number/window-number.el")
(autoload 'window-number-mode "window-number" "comment" t)
(autoload 'window-number-meta-mode "window-number" "comment" t)

;; Window settings
;;
;; Again, via jrockway

(defun first-matching-buffer (predicate)
  "Return PREDICATE applied to the first buffer where PREDICATE applied to the buffer yields a non-nil value."
  (loop for buf in (buffer-list)
        when (with-current-buffer buf (funcall predicate buf))
        return (with-current-buffer buf (funcall predicate buf))))

(defun fix-windows ()
  "Setup my window config."
  (interactive)
  (let ((current-project
         (first-matching-buffer (lambda (x) (ignore-errors (eproject-name)))))
        (current-irc-window
         (first-matching-buffer (lambda (x) (and (eq major-mode 'rcirc-mode)
                                                 x))))
        (current-shell
         (or (first-matching-buffer (lambda (x)
                                      (and (or (eq major-mode 'eshell-mode)
                                               (eq major-mode 'term-mode))
                                           x)))
             (eshell))))

    (delete-other-windows)
    (split-window-horizontally)
    (split-window-horizontally)
    (window-number-select 1)
    (split-window-vertically)
    (labels ((show (x) (set-window-buffer nil (or x (get-buffer-create "*scratch*")))))
      (window-number-select 1)
      (show current-irc-window)
      (window-number-select 2)
      (show current-shell)
      (let ((cur))
        (loop for i in '(3 4)
              do
              (window-number-select i)
              (show (first-matching-buffer
                     (lambda (x) (and (equal (ignore-errors (eproject-name))
                                             current-project)
                                      (not (equal cur (buffer-name x)))
                                      x))))
              (setf cur (buffer-name (current-buffer))))))
    (balance-windows)))




;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.

(add-to-list 'load-path (expand-file-name "~/emacs/jde/lisp"))
(add-to-list 'load-path (expand-file-name "~/emacs/cedet/common"))
(load-file (expand-file-name "~/emacs/cedet/common/cedet.el"))
;; (add-to-list 'load-path (expand-file-name "~/emacs/elib"))

;; If you want Emacs to defer loading the JDE until you open a 
;; Java file, edit the following line
(setq defer-loading-jde nil)
;; to read:
;;
;;  (setq defer-loading-jde t)
;;

(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
	    (append
	     '(("\\.java\\'" . jde-mode))
	     auto-mode-alist)))
  (require 'jde))



(defun my-jde-mode-hook ()
  (setq c-basic-offset 2))

(add-hook 'jde-mode-hook 'my-jde-mode-hook)


;; Misc
;;
;; Setup Emacs to run bash as its primary shell (via jde setup).

(setq shell-file-name "bash")
(setq shell-command-switch "-c")
(setq explicit-shell-file-name shell-file-name)
(setenv "SHELL" shell-file-name)
(setq explicit-sh-args '("-login" "-i"))

