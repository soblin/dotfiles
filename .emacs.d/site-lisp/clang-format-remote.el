;;; clang-format-remote.el --- clang-format をリモートファイルで使う際の拡張  -*- lexical-binding: t; -*-

;; このファイルを init.el 等から (require 'clang-format-remote) するか、
;; 内容をそのまま init.el に貼り付けてください。
;; clang-format.el がロード済みであることが前提です。

;;; Commentary:
;;
;; TRAMP 経由でリモートホストのファイルを編集している場合、
;; ローカルの clang-format を呼び出しても意味がありません。
;;
;; このパッケージは以下の変更を行います:
;;
;; 1. `clang-format--get-executable':
;;    バッファのファイルがリモートにある場合、リモートホスト上の
;;    clang-format コマンドを返す。ローカルの場合は従来どおり
;;    `clang-format-executable' を返す。
;;
;; 2. `clang-format--region-impl' をアドバイスで置き換え:
;;    - リモートファイル時は `call-process-region' の代わりに
;;      `process-file' を使用する（TRAMP が自動的にリモートで実行する）。
;;    - 実行ファイル名も上記 1. で解決したものを使う。
;;
;; カスタマイズ変数:
;;   `clang-format-remote-executable' … リモート側のコマンド名またはパス
;;                                       (デフォルト: "clang-format")
;;   `clang-format-remote-prefer-local' … non-nil にするとリモートでも
;;                                        ローカルの実行ファイルを使う
;;                                        (従来の挙動に戻す)

;;; Code:

(require 'clang-format)
(require 'tramp nil t)   ; TRAMP がなければ単に無視

;; ---------------------------------------------------------------------------
;; カスタマイズ変数
;; ---------------------------------------------------------------------------

(defgroup clang-format-remote nil
  "clang-format のリモートファイル対応設定。"
  :group 'clang-format)

(defcustom clang-format-remote-executable "clang-format"
  "リモートホスト上で呼び出す clang-format のコマンド名またはフルパス。
ホストごとに異なるパスを指定したい場合は
`clang-format-remote-executable-alist' を使ってください。"
  :type 'string
  :group 'clang-format-remote)

(defcustom clang-format-remote-executable-alist nil
  "ホスト名をキー、実行ファイルパスを値とする連想リスト。
例: \\='((\"build-server\" . \"/opt/llvm/bin/clang-format\")
      (\"dev-box\"      . \"clang-format-18\"))
一致するエントリがなければ `clang-format-remote-executable' が使われます。"
  :type '(alist :key-type string :value-type string)
  :group 'clang-format-remote)

(defcustom clang-format-remote-prefer-local nil
  "non-nil にすると、リモートファイルでもローカルの clang-format を使います。
これにより本パッケージの動作を無効化できます。"
  :type 'boolean
  :group 'clang-format-remote)

;; ---------------------------------------------------------------------------
;; ヘルパー関数
;; ---------------------------------------------------------------------------

(defun clang-format-remote--file-remote-p (filename)
  "FILENAME がリモートファイルかどうかを返す。
TRAMP が利用可能な場合は `file-remote-p' を使い、
そうでなければ nil を返す。"
  (and (featurep 'tramp)
       filename
       (file-remote-p filename)))

(defun clang-format-remote--host (filename)
  "TRAMP の FILENAME からホスト名を取り出して返す。
リモートファイルでなければ nil。"
  (when (clang-format-remote--file-remote-p filename)
    (tramp-file-name-host
     (tramp-dissect-file-name filename))))

(defun clang-format-remote--get-executable (&optional filename)
  "FILENAME (省略時はカレントバッファのファイル名) に応じた
clang-format 実行ファイル名を返す。

- リモートファイル かつ `clang-format-remote-prefer-local' が nil の場合:
    1. `clang-format-remote-executable-alist' でホスト名を検索
    2. 見つからなければ `clang-format-remote-executable'
- それ以外: `clang-format-executable'"
  (let* ((fname (or filename (buffer-file-name (buffer-base-buffer))))
         (remote-p (clang-format-remote--file-remote-p fname)))
    (if (and remote-p (not clang-format-remote-prefer-local))
        (let* ((host (clang-format-remote--host fname))
               (entry (and host
                           (assoc host clang-format-remote-executable-alist))))
          (if entry
              (cdr entry)
            clang-format-remote-executable))
      ;; ローカル or prefer-local が有効
      clang-format-executable)))

;; ---------------------------------------------------------------------------
;; `clang-format--region-impl' の置き換え
;;
;; オリジナルは (apply #'call-process-region ...) を使っているが、
;; TRAMP 越しのリモートファイルに対しては `process-file' を使う必要がある。
;; `process-file' は `default-directory' が TRAMP パスであれば自動的に
;; リモートホスト上でコマンドを実行してくれる。
;;
;; ここでは元関数を完全に再定義（上書き）する方式を採用する。
;; アドバイスより確実で、将来の upstream 変更に追従しやすい。
;; ---------------------------------------------------------------------------

(defun clang-format--region-impl (start end &optional style assume-file-name lines)
  "clang-format-remote: リモートファイル対応版の `clang-format--region-impl'。
START/END/STYLE/ASSUME-FILE-NAME/LINES の意味はオリジナルと同じ。

リモートファイルを編集中の場合は `process-file' を使ってリモートホスト上の
clang-format を呼び出す。ローカルファイルの場合は従来と同じ `call-process-region'
を使う。"
  (unless style
    (setq style clang-format-style))
  (unless assume-file-name
    (setq assume-file-name (buffer-file-name (buffer-base-buffer))))

  ;; ---- ここがカスタマイズの核心: 実行ファイルを動的に決定 ----
  (let ((executable (clang-format-remote--get-executable assume-file-name))
        (is-remote  (clang-format-remote--file-remote-p assume-file-name)))

    (when lines
      (setq lines (mapcar (lambda (range)
                            (format "--lines=%d:%d" (car range) (cdr range)))
                          lines)))

    (let ((file-start (clang-format--bufferpos-to-filepos start 'approximate
                                                          'utf-8-unix))
          (file-end   (clang-format--bufferpos-to-filepos end   'approximate
                                                          'utf-8-unix))
          (cursor     (clang-format--bufferpos-to-filepos (point) 'exact
                                                          'utf-8-unix))
          (temp-buffer (generate-new-buffer " *clang-format-temp*"))
          (temp-file   (make-temp-file "clang-format"))
          (default-process-coding-system '(utf-8-unix . utf-8-unix)))

      (unwind-protect
          (let* ((args `("--output-replacements-xml"
                         ,@(and assume-file-name
                                (list "--assume-filename"
                                      ;; リモートパスからローカルパス部分だけ渡す
                                      (if is-remote
                                          (tramp-file-local-name assume-file-name)
                                        assume-file-name)))
                         ,@(and style (list "--style" style))
                         "--fallback-style" ,clang-format-fallback-style
                         ,@(and lines lines)
                         ,@(and (not lines)
                                (list "--offset" (number-to-string file-start)
                                      "--length" (number-to-string
                                                  (- file-end file-start))))
                         "--cursor" ,(number-to-string cursor)))
                 ;; リモートの場合は process-file を使う。
                 ;; process-file は default-directory が TRAMP パスのとき
                 ;; 自動でリモート実行される。
                 ;; ローカルの場合は従来どおり call-process-region。
                 (status
                  (if is-remote
                      ;; process-file はバッファ内容を stdin に送らないため、
                      ;; 一旦バッファをリモートの一時ファイルに書き出して渡す。
                      (let* ((remote-tmp
                              (tramp-make-tramp-file-name
                               (tramp-dissect-file-name assume-file-name)
                               (concat "/tmp/clang-format-src-"
                                       (format "%d" (random 100000)))))
                             (_ (write-region start end remote-tmp nil 'nomessage))
                             (result
                              (apply #'process-file
                                     executable
                                     remote-tmp          ; stdin = リモート一時ファイル
                                     `(,temp-buffer ,temp-file)
                                     nil
                                     args)))
                        (ignore-errors (delete-file remote-tmp))
                        result)
                    ;; ローカル: 元と同じ call-process-region
                    (apply #'call-process-region
                           nil nil executable
                           nil `(,temp-buffer ,temp-file) nil
                           args)))
                 (stderr
                  (with-temp-buffer
                    (unless (zerop (cadr (insert-file-contents temp-file)))
                      (insert ": "))
                    (buffer-substring-no-properties
                     (point-min) (line-end-position)))))

            (cond
             ((stringp status)
              (error "(clang-format killed by signal %s%s)" status stderr))
             ((not (zerop status))
              (error "(clang-format failed with code %d%s)" status stderr)))

            (cl-destructuring-bind (replacements cursor incomplete-format)
                (with-current-buffer temp-buffer
                  (clang-format--extract (car (xml-parse-region))))
              (save-excursion
                (dolist (rpl replacements)
                  (apply #'clang-format--replace rpl)))
              (when cursor
                (goto-char (clang-format--filepos-to-bufferpos cursor 'exact
                                                               'utf-8-unix)))
              (if incomplete-format
                  (message "(clang-format: incomplete (syntax errors)%s)" stderr)
                (message "(clang-format: success [%s]%s)"
                         (if is-remote "remote" "local")
                         stderr))))

        (with-demoted-errors "clang-format: Failed to delete temporary file: %S"
          (delete-file temp-file))
        (when (buffer-name temp-buffer) (kill-buffer temp-buffer))))))

;; ---------------------------------------------------------------------------
;; 対話的確認コマンド (任意)
;; ---------------------------------------------------------------------------

(defun clang-format-remote-show-executable ()
  "現在のバッファで使われる clang-format 実行ファイルをミニバッファに表示する。"
  (interactive)
  (let* ((fname (buffer-file-name (buffer-base-buffer)))
         (exe   (clang-format-remote--get-executable fname))
         (where (if (clang-format-remote--file-remote-p fname) "remote" "local")))
    (message "clang-format (%s): %s" where exe)))

(provide 'clang-format-remote)

;;; clang-format-remote.el ends here
