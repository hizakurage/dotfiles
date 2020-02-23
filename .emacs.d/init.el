;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; el-get
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/dimitri/el-get
;; Requirements
;; - Install el-get first
;;    git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(el-get-bundle with-eval-after-load-feature) ;; From el-get.info

(el-get-bundle ag)

(el-get-bundle company-mode
  ;; https://github.com/company-mode/company-mode/issues/227
  (with-eval-after-load 'company
    ;; https://qiita.com/syohex/items/8d21d7422f14e9b53b17
    (setq company-idle-delay 0)
    (setq company-minimum-prefix-length 2)
    (setq company-selection-wrap-around t)
    (set-face-attribute 'company-tooltip nil
                        :foreground "black" :background "lightgrey")
    (set-face-attribute 'company-tooltip-common nil
                        :foreground "black" :background "lightgrey")
    (set-face-attribute 'company-tooltip-common-selection nil
                        :foreground "white" :background "steelblue")
    (set-face-attribute 'company-tooltip-selection nil
                        :foreground "black" :background "steelblue")
    (set-face-attribute 'company-preview-common nil
                        :background nil :foreground "lightgrey" :underline t)
    (set-face-attribute 'company-scrollbar-fg nil
                        :background "orange")
    (set-face-attribute 'company-scrollbar-bg nil
                        :background "gray40")
    (define-key company-active-map (kbd "C-s") 'company-filter-candidates))
  (global-company-mode))

(el-get-bundle dash)

(el-get-bundle fill-column-indicator)

(el-get-bundle flycheck
  ;; https://www.flycheck.org/en/latest/user/installation.html
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(el-get-bundle go-mode)

(el-get-bundle google-translate
  (require 'google-translate)
  ;; http://emacs.rubikitch.com/google-translate-sentence/
  (defvar google-translate-english-chars "[:ascii:]’“”–"
    "これらの文字が含まれているときは英語とみなす")
  (defun google-translate-enja-or-jaen (&optional string)
    "regionか、現在のセンテンスを言語自動判別でGoogle翻訳する。"
    (interactive)
    (setq string
          (cond ((stringp string) string)
                (current-prefix-arg
                 (read-string "Google Translate: "))
                ((use-region-p)
                 (buffer-substring (region-beginning) (region-end)))
                (t
                 (save-excursion
                   (let (s)
                     (forward-char 1)
                     (backward-sentence)
                     (setq s (point))
                     (forward-sentence)
                     (buffer-substring s (point)))))))
    (let* ((asciip (string-match
                    (format "\\`[%s]+\\'" google-translate-english-chars)
                    string)))
      (run-at-time 0.1 nil 'deactivate-mark)
      (google-translate-translate
       (if asciip "en" "ja")
       (if asciip "ja" "en")
       string)))
  (global-set-key (kbd "C-c t") 'google-translate-enja-or-jaen)

  ;; Workaround
  ;; https://qiita.com/akicho8/items/cae976cb3286f51e4632
  ;; https://github.com/atykhonov/google-translate/issues/98
  (defun google-translate-json-suggestion (json)
    "Retrieve from JSON (which returns by the
`google-translate-request' function) suggestion. This function
does matter when translating misspelled word. So instead of
translation it is possible to get suggestion."
    (let ((info (aref json 7)))
      (if (and info (> (length info) 0))
          (aref info 1)
        nil))))

(el-get-bundle helm
  ;; https://qiita.com/jabberwocky0139/items/86df1d3108e147c69e2c
  (helm-mode 1)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x t") 'helm-recentf)
  (global-set-key (kbd "<help> w") 'helm-man-woman)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-:") 'helm-eval-expression))
(el-get-bundle magit
  (global-set-key (kbd "C-x g") 'magit-status)
  )

(el-get-bundle markdown-mode
  (global-set-key (kbd "C-c m") 'markdown-mode)
  (setq markdown-fontify-code-blocks-natively t) ;; enable syntax highlight in code block
  )

(el-get-bundle popwin)

(el-get-bundle volatile-highlights)

(el-get-bundle yaml-mode)

(el-get-bundle emacswiki:fuzzy-format
  (require 'fuzzy-format)
  (setq fuzzy-format-default-indent-tabs-mode nil)
  (global-fuzzy-format-mode t))

(el-get-bundle helm-gtags
  (add-hook 'helm-gtags-mode-hook
            (lambda ()
              (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
              (local-set-key (kbd "M-a") 'helm-gtags-pop-stack)
              (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
              (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
              (local-set-key (kbd "M-j") 'helm-gtags-find-pattern)))
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c-mode-common-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'java-mode-hook 'helm-gtags-mode)
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  (add-hook 'ruby-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode))

(el-get-bundle m4-mode
  :url "https://raw.githubusercontent.com/jwiegley/emacs-release/master/lisp/progmodes/m4-mode.el"
  :features m4-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; recentf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://tomoya.hatenadiary.org/entry/20110217/1297928222
;; https://qiita.com/tadsan/items/68b53c2b0e8bb87a78d7
(recentf-mode 1)
(setq recentf-max-saved-items 2000) ;; Keep latest 2000 files up
(setq recentf-auto-cleanup 'never) ;;
(setq recentf-exclude '("/recentf" "COMMIT_EDITMSG"))
(setq recent-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq undo-limit 1000000)
(setq undo-strong-limit 13000000)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File save
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add executable permission if a file has shebang
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; Add final new line when file saved
(setq require-final-newline t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Disable Startup message buffer
(setq inhibit-startup-message t)

;; Suppress beep
;; https://qiita.com/ongaeshi/items/696407fc6c42072add54
(setq ring-bell-function 'ignore)

;; Hadle escape sequence in shell-mode
;; http://d.hatena.ne.jp/hiboma/20061031/1162277851
(autoload 'ansi-color-for-comint-mode-on
  "ansi-color"
  "Set 'ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Highlight parens
(show-paren-mode)

;; Show column number in mode-line
(column-number-mode t)

;; Hide password on shell-mode
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; Hide menu bar when emacs running in window mode
(if window-system (menu-bar-mode 1) (menu-bar-mode -1))

;; truncate line in divided window
;; https://beiznotes.org/200907131247476145-2/
(setq-default truncate-partial-width-windows t)
(setq-default truncate-lines t)

;; Custom setting by `M-x list-faces-display`
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:underline t))))
 '(markdown-header-delimiter-face ((t (:inherit nil :foreground "color-161" :weight bold))))
 '(markdown-header-face ((t (:inherit nil :background "color-242" :underline t :weight bold))))
 '(markdown-header-face-1 ((t (:inherit nil :foreground "color-40" :weight bold :height 1.0))))
 '(markdown-header-face-2 ((t (:inherit nil :foreground "color-33" :height 1.0))))
 '(markdown-header-face-3 ((t (:foreground "color-178" :height 1.0))))
 '(markdown-header-face-4 ((t (:foreground "color-105" :height 1.0))))
 '(markdown-header-face-5 ((t (:foreground "color-219" :weight bold :height 1.0))))
 '(markdown-header-face-6 ((t (:foreground "color-244" :weight bold))))
 '(markdown-italic-face ((t (:inherit nil))))
 '(markdown-list-face ((t (:foreground "color-135"))))
 '(mode-line ((t (:background "color-153" :foreground "black" :box (:line-width -1 :style released-button)))))
 '(mode-line-inactive ((t (:inherit mode-line :background "grey30" :foreground "color-243" :box (:line-width -1 :color "grey40") :weight light)))))

;; Hilight current line
;; http://keisanbutsuriya.hateblo.jp/entry/2015/02/01/162035
(global-hl-line-mode t)

;; volatile-highlights
;; http://keisanbutsuriya.hateblo.jp/entry/2015/02/01/162035
;; Temporary highlight an area changed by yank or undo
(volatile-highlights-mode t)

;; Show current function name in status-line by which-function-mode
;; https://stackoverflow.com/questions/16985544/display-function-name-in-status-line
(which-function-mode 1)

;; line number
(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode)
  (setq linum-format "%d ")
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defalias 'yes-or-no-p 'y-or-n-p)

;; scroll file line by line
;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=sane-next-line
(defun sane-next-line (arg)
  "Goto next line by ARG steps with scrolling sanely if needed."
  (interactive "p")
  ;;(let ((newpt (save-excursion (line-move arg) (point))))
  (let ((newpt (save-excursion (next-line arg) (point))))
    (while (null (pos-visible-in-window-p newpt))
      (if (< arg 0) (scroll-down 1) (scroll-up 1)))
    (goto-char newpt)
    (setq this-command 'next-line)
    ()))
(defun sane-previous-line (arg)
  "Goto previous line by ARG steps with scrolling back sanely if needed."
  (interactive "p")
  (sane-next-line (- arg))
  (setq this-command 'previous-line)
  ())
(defun sane-newline (arg)
  "Put newline\(s\) by ARG with scrolling sanely if needed."
  (interactive "p")
  (let ((newpt (save-excursion (newline arg) (indent-according-to-mode) (point))))
    (while (null (pos-visible-in-window-p newpt)) (scroll-up 1))
    (goto-char newpt)
    (setq this-command 'newline)
    ()))
(global-set-key (kbd "<up>") 'sane-previous-line)
(global-set-key (kbd "<down>") 'sane-next-line)
(global-set-key (kbd "C-m") 'sane-newline)
(global-set-key (kbd "C-n") 'sane-next-line)
(global-set-key (kbd "C-p") 'sane-previous-line)
(global-set-key (kbd "M-c") 'help-command)

;; The opposite of forward-window
(defun backward-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-x O") 'backward-window)

;; window split as tmux
(global-set-key (kbd "C-x -") (lambda nil (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "C-x |") (lambda nil (interactive) (split-window-right) (other-window 1)))

;; Window resize
(global-set-key (kbd "C-c l") (lambda () (interactive) (enlarge-window-horizontally 8)))
(global-set-key (kbd "C-c h") (lambda () (interactive) (shrink-window-horizontally 8)))
(global-set-key (kbd "C-c j") (lambda () (interactive) (enlarge-window 8)))
(global-set-key (kbd "C-c k") (lambda () (interactive) (shrink-window 8)))

;; Goto line
(global-set-key (kbd "M-g") 'goto-line)

;; Disable transpose-character w/ C-t
(global-set-key (kbd "C-t") nil)

;; C-h as DEL
;; https://qiita.com/takc923/items/e279f223dbb4040b1157
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-k kill whole line at once
(setq kill-whole-line t)

;; Indent without tab
(setq-default indent-tabs-mode nil)

;; New line indentation
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-j") 'newline)

;; Delete rectangle
(global-set-key (kbd "C-c :") 'delete-rectangle)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq python-indent-guess-indent-offset nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key bindings docs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://dqn.sakusakutto.jp/2012/04/emacs-global-set-key-define-key_global-map.html
;; http://d.hatena.ne.jp/tequilasunset/20100425/p1
;; http://d.hatena.ne.jp/tama_sh/20110206/1296976730

;;; init.el ends here
