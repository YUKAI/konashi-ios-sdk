<a href="http://konashi.ux-xu.com"><img src="http://konashi.ux-xu.com/img/header_logo.png" width="200" /></a><br/>
physical computing toolkit for smartphones and tablets

<a href="http://konashi.ux-xu.com">http://konashi.ux-xu.com</a>

___

<img src="http://konashi.ux-xu.com/img/documents/i2c.png" width="600" />

___

## Getting Started

ここでは、konashi に搭載されているLEDを点灯させる手順を説明します。

(この Gettings Started で作られた xcode のプロジェクトは、konashi ライブラリの <a href="https://github.com/YUKAI/konashi-ios-sdk/tree/master/samples/GettingStarted" target="_blank"><code>konashi-ios-sdk/samples/GettingStarted</code></a> にあります。)

#### 0. 用意するもの
- konashi
- xcode最新版が動くMacbook, iMac
- BLE搭載のiPhone もしくは iPad
- iOS Developer Program (実機テストをする場合)

#### 1. konashi ライブラリを取得
[GitHub](https://github.com/YUKAI/konashi-ios-sdk) のリポジトリを clone してください。

```
$ git clone git@github.com:YUKAI/konashi-ios-sdk.git
```

もしくは [こちらから最新版のライブラリをダウンロード](https://github.com/YUKAI/konashi-ios-sdk/archive/master.zip)してください。

#### 2. xcode で新規プロジェクトを作成

`Single View Application` のプロジェクトを作成します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs0.png" width="500" />

#### 3. Core Bluetooth Frameworkをプロジェクトに追加

プロジェクトの「Targets」のサマリーを表示し、`Linked frameworks and Libraries` の＋ボタンをクリックします。

<img src="http://konashi.ux-xu.com/img/getting_started/gs1.png" width="500" />

検索ボックスに「bluetooth」と入力すると, `CoreBluetooth.framework` が表示されるので追加します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs2.png" width="400" />

#### 4. konashi ライブラリをプロジェクトに追加

1.で取得したソースの中にある`konashi-ios-sdk/Konashi` ディレクトリをプロジェクトにドラッグ&ドロップして追加します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs3.png" width="500" />

<img src="http://konashi.ux-xu.com/img/getting_started/gs4.png" width="500" />


#### 5. 「konashi と接続する」ボタンを追加

konashi と接続するためのボタンをUIに追加します。

`MainStoryboard.storyboard` を開き、ボタンを ViewControllerに配置します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs5.png" width="500" />

次に、そのボタンを押した時に実行される関数を設定します。

右上の蝶ネクタイアイコンのボタンをクリックしてアシスタントエディタモードにし、右のソースコードを `ViewController.h` にします。そして以下のように `- (IBAction)find:(id)sender;` を追加してください。

```objc
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)find:(id)sender;   // add this line

@end
```

最後にボタンのタップと関数を紐付けます。

control キーを押しながら、左側に表示されているボタンを、右側の `- (IBAction)find:(id)sender;` にドラッグアンドドロップしてください。

<img src="http://konashi.ux-xu.com/img/getting_started/gs6.png" width="500" />


#### 6. ViewControllerのコードを書く

`ViewController.m` に以下のコードを書いてください。

```objc
#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (void)ready
{
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi digitalWrite:LED2 value:HIGH];
}

@end
```

#### 7. iOS デバイスの Bluetooth を有効にする

konashi は通信するために Bluetooth 4.0 (Bluetooth Low Energy) を使用します。ですので、アプリを実行する前に iOS デバイスの Bluetooth 機能を有効にします。(すでに有効になっている方はこの項目をスキップしてください)

iOSデバイスの「設定」を開き、表示されたリストの中の「Bluetooth」を選択します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs7.png" width="300" />

Bluetooth の項目が `オフ` になっている場合は `オン` に変更してください。デバイスに検索中という項目が表示されますが、konashiとは関係ないのでホームボタンを押して設定を終了します。

<img src="http://konashi.ux-xu.com/img/getting_started/gs8.png" width="300" />

#### 8. konashi をiOSデバイスから動かす

用意は整いました！

konashi にコイン電池を差し込むか microUSBケーブルを接続して konashi の電源を供給し、プロジェクトを Run してください。

アプリが起動したら Find ボタンを押してみましょう。

すると接続できる konashi のリストが表示されるので、接続する konashi を選択し、 Done ボタンをタップしてください。

<img src="http://konashi.ux-xu.com/img/getting_started/gs9.png" width="300" />

しばらくして LED2 が点灯すれば成功です！

<img src="http://konashi.ux-xu.com/img/getting_started/gs10.png" width="500" />

#### 次にやることは…

<a href="http://konashi.ux-xu.com/documents/">Documents</a> に機能や関数の詳しい説明がありますのでご覧ください。

また、<a href="https://github.com/YUKAI/konashi-ios-sdk/tree/master/samples">konashi-ios-sdk/samples</a> にすべての機能を網羅したサンプルがありますので、それを元に konashi を触っていくことをおすすめします。

