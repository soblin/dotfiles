# dotfiles

個人用の `dotfiles` のレポジトリ.

## シンボリックリンクの設定

```bash
./install.sh
```

する．

## elpaの扱い

elpaのパッケージは別のレポジトリで管理することにした．

### pullするとき

変更を確認する．

```
git fetch
```

その後取り込む．

```
git merge origin/master
```

## tmux

tmuxのキーバインドは以下の通り.

- `C-z c` で **ホームディレクトリで** 新しいwindowをつくる
- `C-z C-c` で **現在のディレクトリで** 新しいwindowをつくる
- `C-z k` で現在のwindowを消去
- `C-z n(p)` でnext(right), previous(left)のwindowへ移動
- `C-z {0-9}` で番号のwindowに移動
- `C-z |` で **現在のディレクトリで** 縦にpaneを作る
- `C-z -` で **現在のディレクトリで** 横にpaneを作る

コピーアンドペーストは以下の手順.

1. `C-z [` で画面上をカーソルで移動するモードに入る.
2. `C-z @` で現在のカーソル位置からカーソルを動かしたところまでを選択するモードに入る.
3. `C-z {p, n, f, b}` (Emacsと同じ)で範囲を選択.
4. `Alt-w` でコピーできる.
5. `C-z C-y` でペースト.

これをシステムのクリップボードに移すために `pbcopy` コマンドを作った．

## languages

### Julia

`~/.local/opt/`に`julia-x.x.x`のディレクトリをインストールし，`~/.local/bin/julia`へのsymlinkを張る．

### Haskell

```bash
sudo apt install haskell-stack
stack upgrade
```

で`~/.local/bin/`に`stack`をインストール．

### Rust

`~/.local/bin/`にツールチェーンをインストール．

### ROS2

colconに付属する`argcomplete`はバージョンが古いため`fish`に対応していない．最新の`argcomplete`を[github](https://github.com/kislyuk/argcomplete)からクローンしてきて

```
python3 setup.py install --user
```

する．`register-python-argcomplete`を使えるようになる．
