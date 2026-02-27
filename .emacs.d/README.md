# elispのメモ

## boundp

`boundp`は変数が`void`ではないかをチェックする関数．`fboundp`は関数定義が`void`ではないかをチェックする関数

## alist

`alist`は`association list`の略で，

```lisp
(
(key1 . value1)
...
)
```

のような形式になっている．

https://qiita.com/kosh04/items/0df6edbbd6ac4efa1b8b にあるように，`(cdr (assq '<key> <map>))`で参照できるらしい．
