//
//  ViewController.m
//  HardwareSample
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	[[Konashi shared] setConnectedHandler:^{
		NSLog(@"CONNECTED");
	}];
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"READY");
		
		self.statusMessage.hidden = NO;
		
		// LED2 on
		[Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
		[Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
		
		// Set RSSI timer
		NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:01.0f target:self selector:@selector(onRSSITimer:) userInfo:nil repeats:YES];
		[tm fire];
	}];
	[[Konashi shared] setSignalStrengthDidUpdateHandler:^(int value) {
		float progress = -1.0 * [Konashi signalStrengthRead];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.dbBar.progress = progress / 100;
		
		NSLog(@"RSSI: %ddb", [Konashi signalStrengthRead]);
	}];
	[[Konashi shared] setBatteryLevelDidUpdateHandler:^(int value) {
		float progress = [Konashi batteryLevelRead];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.batteryBar.progress = progress / 100;
		
		NSLog(@"BATTERY LEVEL: %d%%", [Konashi batteryLevelRead]);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)reset:(id)sender {
    [Konashi reset];
}

- (IBAction)requestReadBattery:(id)sender {
    [Konashi batteryLevelReadRequest];
}

- (void) onRSSITimer:(NSTimer*)timer
{
    [Konashi signalStrengthReadRequest];
}

@end
