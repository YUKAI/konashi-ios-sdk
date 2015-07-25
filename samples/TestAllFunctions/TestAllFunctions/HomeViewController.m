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
	[[Konashi shared] setConnectedHandler:^{
		NSLog(@"CONNECTED");
	}];
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"READY");
		
		self.statusMessage.hidden = NO;
		[self.connectButton setTitle: @"接続を切る" forState:UIControlStateNormal];
		
		// 電波強度タイマー
		NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:01.0f target:self selector:@selector(onRSSITimer:) userInfo:nil repeats:YES];
		[tm fire];
	}];
	
    // 電波強度
	
	[[Konashi shared] setSignalStrengthDidUpdateHandler:^(int value) {
		float progress = -1.0 * [Konashi signalStrengthRead];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.dbBar.progress = progress / 100;
		
		NSLog(@"RSSI: %ddb", [Konashi signalStrengthRead]);
	}];
	
    // バッテリー
	[[Konashi shared] setBatteryLevelDidUpdateHandler:^(int value) {
		float progress = [Konashi batteryLevelRead];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.batteryBar.progress = progress / 100;
		
		NSLog(@"BATTERY LEVEL: %d%%", [Konashi batteryLevelRead]);
	}];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventDidFindSoftwareRevisionStringNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		self.softwareRevisionString.text = [NSString stringWithFormat:@"Software Revision:%@", [Konashi softwareRevisionString]];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    if ( [Konashi isConnected] ) {
        [Konashi disconnect];
        [self.connectButton setTitle: @"konashi に接続する" forState:UIControlStateNormal];
    } else {
        [Konashi find];
    }
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

- (IBAction)reset:(id)sender {
    [Konashi reset];
}

///////////////////////////////////////////////////
// 使い方
- (IBAction)howto:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://konashi.ux-xu.com/getting_started/#first_touch"]];
}

///////////////////////////////////////////////////
// 電波強度

- (void) onRSSITimer:(NSTimer*)timer
{
    [Konashi signalStrengthReadRequest];
}

///////////////////////////////////////////////////
// バッテリー

- (IBAction)getBattery:(id)sender {
    [Konashi batteryLevelReadRequest];
}

@end
