<img src="http://konashi.ux-xu.com/img/header_logo.png" width="200" />

physical computing toolkit for smartphones and tablets

___

<img src="http://konashi.ux-xu.com/img/documents/i2c.png" width="600" />

___

## Getting started

#### 1. Get konashi library and samples
Clone konashi repository.

```
$ git clone git@github.com:YUKAI/konashi-ios-sdk.git
```

or [download latest version](https://github.com/YUKAI/konashi-ios-sdk/archive/master.zip).

#### 2. Create xcode project

Create new project as single view application on xcode.

<img src="http://konashi.ux-xu.com/img/getting_started/gs0.png" width="500" />

#### 3. Add Core Bluetooth Framework

Show target summary and click Add button of "Linked frameworks and Libraries".

<img src="http://konashi.ux-xu.com/img/getting_started/gs1.png" width="500" />

Type "bluetooth", then you can see CoreBluetooth.framework. Add this.

<img src="http://konashi.ux-xu.com/img/getting_started/gs2.png" width="400" />

#### 4. Add konashi library to your project

D&D `konashi-ios-sdk/Konashi` directory to your project.

<img src="http://konashi.ux-xu.com/img/getting_started/gs3.png" width="500" />

<img src="http://konashi.ux-xu.com/img/getting_started/gs4.png" width="500" />

#### Write some code

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
    
    [Konashi find];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ready
{
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi digitalWrite:LED2 value:HIGH];
}
@end
```

that's it.

Set the coin battery to the konashi and let's run your project.
