//
//  HomeViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "HomeViewController.h"
#import "Konashi.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // コネクション系
	[Konashi createKonashiWithConnectedHandler:^(Konashi *konashi) {
		[self connected];
	} disconnectedHandler:^(Konashi *konashi) {
		
	} readyHandler:^(Konashi *konashi) {
		[self ready];
	}];
//    [Konashi addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
//    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    
    // 電波強度
	[Konashi sharedKonashi].signalStrengthDidUpdateHandler = ^(Konashi *konashi, int value) {
		float progress = -1.0 * value;
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.dbBar.progress = progress / 100;
	};
//    [Konashi addObserver:self selector:@selector(updateRSSI) name:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];

    // バッテリー
	[Konashi sharedKonashi].batteryLevelDidUpdateHandler = ^(Konashi *konashi, int value) {
		float progress = value;
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.batteryBar.progress = progress / 100;
		
		NSLog(@"BATTERY LEVEL: %d%%", [[Konashi sharedKonashi] batteryLevelRead]);
	};
//    [Konashi addObserver:self selector:@selector(updateBatteryLevel) name:KONASHI_EVENT_UPDATE_BATTERY_LEVEL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    if ( [[Konashi sharedKonashi] isConnected] ) {
        [[Konashi sharedKonashi] disconnect];
        [self.connectButton setTitle: @"konashi に接続する" forState:UIControlStateNormal];
    } else {
        [[Konashi sharedKonashi] find];
    }
}

- (IBAction)disconnect:(id)sender {
    [[Konashi sharedKonashi] disconnect];
}

- (IBAction)reset:(id)sender {
    [[Konashi sharedKonashi] reset];
}

///////////////////////////////////////////////////
// 使い方
- (IBAction)howto:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://konashi.ux-xu.com/getting_started/#first_touch"]];
}

- (void)connected
{
    NSLog(@"CONNECTED");
}

- (void)ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
    [self.connectButton setTitle: @"接続を切る" forState:UIControlStateNormal];

    // 電波強度タイマー
    NSTimer *tm = [NSTimer
                   scheduledTimerWithTimeInterval:01.0f
                   target:self
                   selector:@selector(onRSSITimer:)
                   userInfo:nil
                   repeats:YES
                   ];
    [tm fire];
}

///////////////////////////////////////////////////
// 電波強度

- (void) onRSSITimer:(NSTimer*)timer
{
    [[Konashi sharedKonashi] signalStrengthReadRequest];
}

- (void) updateRSSI
{
    float progress = -1.0 * [[Konashi sharedKonashi] signalStrengthRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.dbBar.progress = progress / 100;
    
    //NSLog(@"RSSI: %ddb", [Konashi signalStrengthRead]);
}


///////////////////////////////////////////////////
// バッテリー

- (IBAction)getBattery:(id)sender {
    [[Konashi sharedKonashi] batteryLevelReadRequest];
}

- (void) updateBatteryLevel
{
    float progress = [[Konashi sharedKonashi] batteryLevelRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.batteryBar.progress = progress / 100;
    
    NSLog(@"BATTERY LEVEL: %d%%", [[Konashi sharedKonashi] batteryLevelRead]);
}

@end
