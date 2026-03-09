# emacs setting

"Mastering Emacs"を読み，

- https://github.com/purcell/emacs.d
- https://github.com/bbatsov/prelude

を参考にEmacs30向けに設定をモダン化した．

## elispのメモ

### boundp

`boundp`は変数が`void`ではないかをチェックする関数．`fboundp`は関数定義が`void`ではないかをチェックする関数

### alist

`alist`は`association list`の略で，

```lisp
(
(key1 . value1)
...
)
```

のような形式になっている．

https://qiita.com/kosh04/items/0df6edbbd6ac4efa1b8b にあるように，`(cdr (assq '<key> <map>))`で参照できる．

### use-package

`:init`などはキーワード引数と呼ばれており，これはマクロなので評価前に展開される．`package`が読み込まれる前に設定される．`setq`は必要．

`:custom`はパッケージの初期化時に評価されるマクロであり，`customize-set-variable`に渡されるので`setq`は不要．つまり

```elisp
(foo 123)
```

は`customize-set-variable 'foo 123`に展開されて`defcustom`の初期化で利用される．

`:config`はパッケージの読込後に評価される．`require`の後に実行されるので，関数の定義ができる．`setq`は必要．
