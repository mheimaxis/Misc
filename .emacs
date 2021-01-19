; some org mode stuff
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; disable line truncatino (where lines can wrap around)
(set-default 'truncate-lines 0)

; add solarized theme to load path
(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized-master")

(setq ring-bell-function 'ignore)

; load solarized theme
; https://github.com/sellout/emacs-color-theme-solarized
(load-theme 'solarized t)

; set defualt window size. expand width of 80 to 120 
; and height of 24 to 47
(when window-system (set-frame-size (selected-frame) 120 48))

; put all common back up files into one directory
(setq backup-directory-alist `(("." . "~/emacs_backup_saves")))
; back-ups are just straight copies (could be slow, assuming worth it)
(setq backup-by-copying t)

; kept some number of backups
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;Make sure the stupid welcome splash doesn't come up
(setq inhibit-startup-message t)

(setq hs-special-modes-alist
      (cons '(verilog-mode "\\<begin\\>\\|\\<task\\>\\|\\<function\\>\\|\\<class\\>\\|\\<module\\>\\|\\<package\\>"
                           "\\<end\\>\\|\\<endtask\\>\\|\\<endfunction\\>\\|\\<endclass\\>\\|\\<endmodule\\>\\|\\<endpackage\\>"
                           nil
                           verilog-forward-sexp-function)
            hs-special-modes-alist))

; Set tab to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

; Always display current function in the modeline
(add-hook 'c-mode-common-hook 
  (lambda ()
    (which-function-mode t)))

(require 'cc-mode)
(setq auto-mode-alist
      (append '(("\\.\\(CC?\\|HH?\\)\\'" . c++-mode)
        ("\\.[ch]\\(pp\\|xx\\|\\+\\+\\)\\'" . c++-mode)
        ("\\.\\(cc\\|hh\\|cbgen\\|list\\)\\'" . c++-mode)
        ) auto-mode-alist ))

(global-font-lock-mode 1)

(setq explicit-shell-file-name "/tool/pandora/bin/bash")

; Enable column nuber mode
(setq column-number-mode t)

; Enable visual feedback on selections
(setq transient-mark-mode t)

; Add .vu fles to Verilog mode
(add-to-list 'auto-mode-alist '("\\.vu\\'" . verilog-mode))

; Add SystemVerilog extension (.sv) to Verilog mode
(add-to-list 'auto-mode-alist '("\\.sv\\'" . verilog-mode))

; Add SystemVerilog extension (.svh) to Verilog mode
(add-to-list 'auto-mode-alist '("\\.svh\\'" . verilog-mode))

; Unbind curly brace keys. CPerl mode freaks out and 
; I can't use them
(add-hook 'cperl-mode-hook
          (lambda()
            (local-unset-key (kbd "{"))))

(add-hook 'cperl-mode-hook
          (lambda()
            (local-unset-key (kbd "}"))))

; Enable useful disabled commands
(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

; Preserve hard links to the file you're editing 
;(this is especially important if you edit system files).
(setq backup-by-copying-when-linked t)

; set the title bar to show file name if available, buffer name otherwise
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

; Turn on mouse wheel scrolling
(if (load "mwheel" t)
    (mwheel-install))

; Additional C-c LETTER key bindings for useful commands
(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-cG" 'goto-char)
(global-set-key "\C-cw" 'delete-region) ; ala C-w and M-C-w
(global-set-key "\C-cc" 'comment-region)
(global-set-key "\C-cu" 'uncomment-region)

; Disable scroll beep (beepUGHbeep)
(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

(show-paren-mode 1) ; turn on paren match highlighting
(setq show-paren-style 'expression) ; highlight entire bracket expression

(global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


(setq minibuffer-max-depth nil)






