;;; emacs init.el

;; フレームタイトル
(setq frame-title-format'("emacs " emacs-version (buffer-file-name " - %f")))

;; 初期画面非表示
(setq inhibit-startup-message t)

;; テーマ設定
(load-theme 'tango-dark t)

;; ツールバー非表示
(tool-bar-mode -1)

;; スクロールバー非表示
(scroll-bar-mode -1)

;; 行番号
(line-number-mode 1)

;; 桁番号表示
(column-number-mode 1)

;; 対応する括弧をハイライト
(show-paren-mode 1)

;; カーソル行色変更
(global-hl-line-mode 1)
(set-face-background 'hl-line "darkolivegreen")

;; フォント設定
(custom-set-faces
 '(default ((t( :family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))

;; Migemoがインストールされていたら有効にする
(require 'migemo nil t)

;; MOZC設定
;; sudo apt-get install emacs-mozc emacs-mozc-binでインストール
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

;; nnで'ん'
(setq quail-japanese-use-double-n t)

;; 文字コード指定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; バックアップファイルを作成しない
(setq make-backup-files nil)

;; オートセーブファイルを作成しない
(setq auto-save-default nil)

;; GDB 関連
;; 有用なバッファを開くモード
(setq gdb-many-windows t)

;; 変数の上にマウスカーソルを置くと値を表示
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;; I/O バッファを表示
(setq gdb-use-separate-io-buffer t)

;; mini buffer に値が表示される
(setq gud-tooltip-echo-area t)

;; 現在の関数名を常に表示する
(which-func-mode 1)
(setq which-func-modes t)

;; LoadPath追加
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elpa")

;; パッケージ取得先設定
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; 大文字入力を楽にする
(require 'sticky)
(use-sticky-key ":" sticky-alist:ja)

;; anything
(require 'anything-startup)
(global-set-key "\C-q" 'anything-for-files)

;; Auto Complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")                 ;; 手動候補表示
(setq ac-use-menu-map t)                   ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)                      ;; 曖昧マッチ

(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         ))
(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))

;; Tabbar
(require 'tabbar)
(tabbar-mode)

(tabbar-mwheel-mode nil)                  ;; マウスホイール無効
(setq tabbar-buffer-groups-function nil)  ;; グループ無効
(setq tabbar-use-images nil)              ;; 画像を使わない

;; キーに割り当てる
(global-set-key (kbd "M-<right>") 'tabbar-forward-tab)
(global-set-key (kbd "M-<left>") 'tabbar-backward-tab)

;; 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

;; タブのセパレーターの長さ
(setq tabbar-separator '(2.0))

;; タブの色
(set-face-attribute
 'tabbar-default nil
 :background "brightblue"
 :foreground "white"
 )
(set-face-attribute
 'tabbar-selected nil
 :background "#ff5f00"
 :foreground "brightwhite"
 :box nil
 )
(set-face-attribute
 'tabbar-modified nil
 :background "brightred"
 :foreground "brightwhite"
 :box nil
 )

;; 表示するバッファ
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; Always include the current buffer.
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((equal "*scratch*" (buffer-name b)) b) ; *scratch*バッファは表示する
                     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

;; Flymake
;;(require 'flymake)

;; C/C++
;;(add-hook 'c-mode-common-hook (lambda () (flymake-mode t)))

;; e2wm
(require 'e2wm)
(global-set-key (kbd "M-+") 'e2wm:start-management)

(e2wm:add-keymap
 e2wm:pst-minor-mode-keymap
 '(("<M-up>"   . e2wm:dp-code)
   ("<M-down>" . e2wm:dp-two)
   ("C-."      . e2wm:pst-history-forward-command)
   ("C-,"      . e2wm:pst-history-back-command)
   ("<M-m>"    . e2wm:pst-window-select-main-command)
   ) e2wm:prefix-key)

;; web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.ctp\\'"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; web-modeの設定
(defun web-mode-hook ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-engines-alist
        '(("php"    . "\\.ctp\\'"))
        )
  )
(add-hook 'web-mode-hook  'web-mode-hook)

;; 色の設定
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#82AE46"))))
 '(web-mode-html-tag-face
   ((t (:foreground "#E6B422" :weight bold))))
 '(web-mode-html-attr-name-face
   ((t (:foreground "#C97586"))))
 '(web-mode-html-attr-value-face
   ((t (:foreground "#82AE46"))))
 '(web-mode-comment-face
   ((t (:foreground "#D9333F"))))
 '(web-mode-server-comment-face
   ((t (:foreground "#D9333F"))))
 '(web-mode-css-rule-face
   ((t (:foreground "#A0D8EF"))))
 '(web-mode-css-pseudo-class-face
   ((t (:foreground "#FF7F00"))))
 '(web-mode-css-at-rule-face
   ((t (:foreground "#FF7F00"))))
)

;; ウインドウ切替(C-t transpose-charsを変更)
(define-key global-map (kbd "C-t") 'other-window)

;; Undo(C-z iconify-or-deiconify-frameを変更)
(define-key global-map (kbd "C-z") 'undo)

;; バックスペース(C-h)
;;(keyboard-translate ?\C-h ?\C-?)
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; C-c cでcompile
(define-key mode-specific-map "c" 'compile)

;; バッファやファイルを選択して開く時に候補を表示
(ido-mode 1)
(ido-everywhere 1)

;; バッファ選択
(global-set-key (kbd "C-x C-b") 'bs-show)

; php-mode
(autoload 'php-mode "php-mode")
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))
(setq php-mode-force-pear t)
(add-hook 'php-mode-user-hook
  '(lambda ()
     (setq php-manual-path "/usr/local/share/php/doc/html")
     (setq php-manual-url "http://www.phppro.jp/phpmanual/")))

; css-mode
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)
