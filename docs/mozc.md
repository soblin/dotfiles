# mozc

mozcで入力を切り替えた際に始めから日本語入力になっていて欲しい（デフォルトでは直接入力）．[このオプションは入ったが](https://github.com/google/mozc/issues/381)，Ubuntu22.04で入るmozcではまだ利用できない．そのため[こちら](https://zenn.dev/ikuya/articles/aa69fd1009b773)に従って上書き更新する．

Dockerfileとしては代わりに

```bash
curl -O https://raw.githubusercontent.com/google/mozc/b0a604f110e01d11107ebbaad09e674cecee34f5/docker/ubuntu22.04/Dockerfile


- RUN apt-get install -y bazel
+ RUN apt-get install -y bazel-7.7.1
+ RUN ln -s /usr/bin/bazel-7.7.1 /usr/bin/bazel
```

を用いること．

その後`~/.config/mozc/ibus_config.textproto`の`mozc-jp`のフィールドを以下のように更新する．

```
engines {
  name : "mozc-jp"
  longname : "Mozc"
  layout : "default"
  layout_variant : ""
  layout_option : ""
  symbol : "あ"
  composition_mode: HIRAGANA # これが一番重要
}
```

その後`ibus write-cache`してから再起動すると始めから日本語入力ができるようになる．

