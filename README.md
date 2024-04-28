# dotfiles

個人用の `dotfiles` のレポジトリ.

## 依存コマンドのインストール・シンボリックリンクの設定

```bash
./install.sh
```

する．

## 日本語入力

mozcで入力を切り替えた際に始めから日本語入力になっていて欲しい（デフォルトでは直接入力）．[このオプションは入ったが](https://github.com/google/mozc/issues/381)，Ubuntu22.04で入るmozcではまだ利用できない．そのためこちらに従って上書き更新する．

https://zenn.dev/ikuya/articles/aa69fd1009b773

その後`~/.config/mozc/ibus_config.textproto`を以下のように更新する．

```
engines {
  name : "mozc-jp"
  longname : "Mozc"
  layout : "default"
  layout_variant : "" # 一応追加
  layout_option : "" # 一応追加
  symbol : "あ" # 一応追加
  composition_mode: HIRAGANA # これが一番重要
}
active_on_launch: False
```

その後`ibus write-cache`してから再起動すると始めから日本語入力ができるようになる．

## tmux

tmuxのキーバインドは以下の通り.

- `C-z c`で**ホームディレクトリで**新しいwindowをつくる
- `C-z C-c`で **現在のディレクトリで**新しいwindowをつくる
- `C-z k`で現在のwindowを消去
- `C-z n(p)`でnext(right), previous(left)のwindowへ移動
- `C-z {0-9}`で番号のwindowに移動
- `C-z |`で**現在のディレクトリで**縦にpaneを作る
- `C-z -`で**現在のディレクトリで**横にpaneを作る
- `C-z o`, `C-z C-o`で隣のpaneに移る
- `C-z M`でsessionを名前付きで保存
- `C-z N`でsessionを名前付きで復帰(補完はできなさそう)

コピーアンドペーストは以下の手順.

1. `C-z [`で画面上をカーソルで移動するモードに入る.
2. `C-z @`で現在のカーソル位置からカーソルを動かしたところまでを選択するモードに入る.
3. `C-z {p, n, f, b}`(Emacsと同じ)で範囲を選択.
4. `Alt-w`でコピーできる.
5. `C-z C-y`でペースト.

これをシステムのクリップボードに移すために`pbcopy`コマンドを作った．マウスで範囲を選択した場合も`pbcopy`コマンドが必要．

## languages

### Julia

`~/.local/opt/`に`julia-x.x.x`のディレクトリをインストールし，`~/.local/bin/julia`へのsymlinkを張る．

### Rust

`~/.local/bin/`にツールチェーンをインストール．

### ROS2

colconに付属する`argcomplete`はバージョンが古いため`fish`に対応していない．

```
pip3 install --user argcomplete==2.0.0
```

すれば，aptで入ったargcompleteとconflictせずに済む．

fishについては[こちらの記事を参照](https://zenn.dev/kenji_miyake/articles/c149cc1f17e168)．

```bash
sudo apt-get install fzf fd-find jq
ln -s $(which fdfind) ~/.local/bin/fd
```

## Emacs

### gccemacsを使う

`kelleyk:ppa`ですでに`emacs-nativecomp`が提供されている．Ubuntu22では

```
sudo snap install emacs --classic
```

でnativecompが手に入るようになったので，こちらの方がすぐにDLできて良い．

### plists

lspを高速にするには[plists](https://emacs-lsp.github.io/lsp-mode/page/performance/#use-plists-for-deserialization)を使うようにコンパイルすべきであるらしい．`eln-cache`を削除してから

```
export LSP_USE_PLISTS=true
OR
set -x export LSP_USE_PLISTS true
```

した上で再度コンパイルするとバイトコードに埋め込まれるようだ(？)．

### elpaの扱い

elpaのパッケージは別のレポジトリで管理する．

### doom-modelineのアイコン

`M-x all-the-icons-install-fonts, nerd-icons-install-fonts`をする必要がある．

### LSP

キーバインドは以下の通り

- `M+.`で定義へのジャンプ，`M+,`で戻る

#### ccls

プロジェクトのrootに`.ccls`を置き，そこに`compile_commands.json`へのシンボリックリンクを貼る(`build/`など)．
- ROSのようにrootの配下にC++のプロジェクト(vcsで管理されている)が複数配置されている場合は，それぞれのプロジェクトでrootの`compile_commands.json`へのリンクを貼らないといけない(TODO: 良い対処法)
- `.hpp`のインデクシングが不十分な気がするので，`compdb`の[この機能](https://github.com/Sarcasm/compdb#generate-a-compilation-database-with-header-files)を使う必要がありそう

```
pip3 install --user compdb
compdb -p build/ list > compile_commands.json
```

#### python

```
pip3 install --user python-language-server rope autopep8 black pyright
```

Pipfileなどで管理されたプロジェクトで補完を行うには`pyvenv`パッケージを利用する．

- https://github.com/emacs-lsp/lsp-mode/issues/1290

`M-x pyvenv-activate`でPipfileがあるフォルダーを選択し`lsp-workspace-restart`すると仮想環境にインストールされたパッケージが認識される． --> もしかするとpipenvに入った状態でemacsを立ち上げる必要もあるかも．

#### rust

```
rustup component add rls rust-analysis rust-src
```

#### 参考

- https://solist.work/blog/posts/language-server-protocol/
