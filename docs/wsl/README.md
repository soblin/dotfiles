# WSL用の設定

WezTermはWindows用をインストールし，`/mnt/c/Users/<User>/.config/wezterm/wezterm.lua`に設定ファイルを置く．

```lua
config.default_domain = 'WSL:Ubuntu-22.04'
config.audible_bell = "Disabled"
```

の設定が追加で必要．

HackGenNFとPowerlineFontsもzipを解凍して直接ファイルをダブルクリックしてインストールする．

- https://github.com/yuru7/HackGen
- https://qiita.com/mosh_shu/items/0dc06e8b4aecf7d68316
