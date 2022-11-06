# dotfiles

個人用の `dotfiles` のレポジトリ.

## 依存コマンドのインストール・シンボリックリンクの設定

```bash
./install.sh
```

する．

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

### Rust

`~/.local/bin/`にツールチェーンをインストール．

### ROS2

colconに付属する`argcomplete`はバージョンが古いため`fish`に対応していない．

```
pip3 install argcomplete=2.0.0 (--user)
```

すれば，aptで入ったargcompleteとconflictせずに済む．

## Emacs

### gccemacsを使う

http://emacs.secretsauce.net/に従ってppaを登録しemacs-nativecompをinstallする（まだofficialでsupportされていないのでinstall.shには入れない）

### elpaの扱い

elpaのパッケージは別のレポジトリで管理する．

### all-the-icons

`M-x all-the-icons-install-fonts`をする必要がある．

### LSP

キーバインドは以下の通り

- `M+.`で定義へのジャンプ，`M+,`で戻る

#### ccls

プロジェクトのrootに`.ccls`を置き，そこに`compile_commands.json`へのシンボリックリンクを貼る(`build/`など)．
- ROSのようにrootの配下にC++のプロジェクト(vcsで管理されている)が複数配置されている場合は，それぞれのプロジェクトでrootの`compile_commands.json`へのリンクを貼らないといけない(TODO: 良い対処法)
- `.hpp`のインデクシングが不十分な気がするので，`compdb`の[この機能](https://github.com/Sarcasm/compdb#generate-a-compilation-database-with-header-files)を使う必要がありそう

```
pip install --user compdb
compdb -p build/ list > compile_commands.json
```

#### python

```
pip install --user python-language-server rope pyflakes yapf autopep8
```

#### rust

```
rustup component add rls rust-analysis rust-src
```

#### 参考

- https://solist.work/blog/posts/language-server-protocol/
