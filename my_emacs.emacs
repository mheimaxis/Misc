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

(add-hook 'before-save-hook 'whitespace-cleanup)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq-default c-basic-offset 2)

(global-set-key "\C-cg" 'goto-line)

;;; Mouse scrolling in terminal emacs
(unless (display-graphic-p)
  ; activate mouse-based scrolling
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)
  )

;;; return from terminal within emacs with C-d
(defun delete-char-or-kill-terminal-buffer (N &optional killflag)
  (interactive "p\nP")
  (if (string= (buffer-name) "*terminal*")
  (kill-buffer (current-buffer))
(delete-char N killflag)))
(global-set-key (kbd "C-d") 'delete-char-or-kill-terminal-buffer)

;;; automatically kill buffer that shows up when closing term
(defun oleh-term-exec-hook ()
  (let* ((buff (current-buffer))
         (proc (get-buffer-process buff)))
    (set-process-sentinel
     proc
     `(lambda (process event)
        (if (string= event "finished\n")
            (kill-buffer ,buff))))))

(add-hook 'term-exec-hook 'oleh-term-exec-hook)

;;; paste into term using C-c C-y
(eval-after-load "term"
  '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

;;; Enable visual feedback on selections
(setq transient-mark-mode t)

(show-paren-mode 1) ; turn on paren match highlighting
(setq show-paren-style 'expression) ; highlight entire bracket expression

;;; Without a selection, copy (M-w) or kill (C-w) the current line.
;;; Is there a way to remove the newline character? I'm sure there is
(defadvice kill-region (before slick-cut activate compile)
  ; When called interactively with no active region, kill a single line instead.
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-ring-save (before slick-copy activate compile)
  ; When called interactively with no active region, copy a single line instead.
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))

(load-theme 'misterioso)

;;; Auto indent yanked text
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      python-mode
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))

(defun quick-copy-line ()
  ; Copy the whole line that point is on and move to the beginning of the next line.
  ; Consecutive calls to this command append each line to the kill-ring.
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end))))
  (message "Quick copy line")
  (beginning-of-line 2))

(global-set-key (kbd "<f11>") 'quick-copy-line)

(defun quick-cut-line ()
  ; Cut the whole line that point is on.
  ; Consecutive calls to this command append each line to the kill-ring.
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-cut-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end)))
    (delete-region beg end))
  (message "Quick cut line")
  (beginning-of-line 1)
  (setq this-command 'quick-cut-line))

(global-set-key (kbd "<f12>") 'quick-cut-line)
