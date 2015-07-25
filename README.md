<a href="http://konashi.ux-xu.com"><img src="http://konashi.ux-xu.com/img/header_logo.png" width="200" /></a><br/>
Physical computing toolkit for smartphones and tablets

[![Version](https://img.shields.io/cocoapods/v/konashi-ios-sdk.svg?style=flat)](http://cocoadocs.org/docsets/konashi-ios-sdk)

[http://konashi.ux-xu.com](http://konashi.ux-xu.com)<br/>
[http://konashi-yukai.tumblr.com](http://konashi-yukai.tumblr.com)

---

<img src="http://konashi.ux-xu.com/img/documents/i2c.png" width="600" />

---

## CocoaPods に対応しました
以下の様な Podfile を作成。

```
source "https://github.com/CocoaPods/Specs.git"
platform :ios, "7.1"
pod "konashi-ios-sdk"
```

そして

```
$ pod install
```


## Getting Started

- [公式ページの Getting Started](http://konashi.ux-xu.com/getting_started/)
  - konashi の基板上の LED を点灯させるまで


## 開発について

### 機能要望やバグ報告をするには
開発者に要望を伝える報告する方法は以下です。

- GitHub の Issues に投稿
  - [https://github.com/YUKAI/konashi-ios-sdk/issues](https://github.com/YUKAI/konashi-ios-sdk/issues)
  - feature-requests、bug、discussion などのラベルをご使用ください。
- Pull Request
  - バグ見つけて修正しといたよ、というときは Pull Request を **develop ブランチ**に送ってください。
  - 詳細は ブランチの運用 をご覧ください。
- “konashi" をキーワードにつぶやく
  - twitter で #konashi のハッシュをつけるか、 konashi というキーワードを使って tweet してください。
  - もしくは konashi をキーワードにブログに書いてください。
- [contact@ux-xu.com](contact@ux-xu.com) にメールする
  - メールでの報告も受け付けています。

### ブランチの運用
[git-flow](https://github.com/nvie/gitflow) を使用しています。各ブランチの役割は以下です。

- master
  - リリース用のブランチです。GitHubでは master ブランチがデフォルトのブランチです。
- develop
  - 開発用のブランチです。
- feature/***
  - 新機能追加やバグ修正を行うブランチです。develop ブランチから feature ブランチを切り、開発が完了後に develop ブランチに merge します。
- release/v***
  - リリース前ブランチです。develop ブランチから release ブランチを切り、テストが終わり次第 master ブランチにマージされます。(現在は基本的に origin に push されません)


### タグの運用
基本的にリリース時にバージョン名でタグを切ります。konashi 公式ページからリンクされる zip ダウンロード先は最新のリリースタグの zip です。

タグ一覧は[こちら](https://github.com/YUKAI/konashi-ios-sdk/tags)。

### Pull Request
**規模の大小関わらず、バグ修正や機能追加などの Pull Request 大歓迎！**

Pull Request を送るにあたっての注意点は以下です。

- 最新の develop ブランチから任意の名前でブランチを切り、実装後に develop ブランチに対して Pull Request を送ってください。
  - master ブランチへの Pull Request は(なるべく)ご遠慮ください。

## ライセンス
konashi のソフトウェアのソースコード、ハードウェアに関するドキュメント・ファイルのライセンスは以下です。

- ソフトウェア
  - konashi-ios-sdk のソースコードは [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html) のもと公開されています。
- ハードウェア
  - konashi の回路図などハードウェア関連のドキュメント・ファイルのライセンスは [クリエイティブ・コモンズ・ライセンス「表示-継承 2.1 日本」](http://creativecommons.org/licenses/by-sa/2.1/jp/deed.ja)です。これに従う場合に限り、自由に複製、頒布、二次的著作物を作成することができます。
  - 回路図のデータ(eagleライブラリ)は3月上旬公開予定です。
- konashi のBLEモジュールのファームウェアは [csr社](http://www.csr.com/) とのNDAのため公開しておりません。
