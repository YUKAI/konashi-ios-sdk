//
//  HomeViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "HomeViewController.h"
#import "Konashi.h"
#import "Konashi+JavaScriptCore.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"updateRSSI" hendler:^(JSValue *value) {
		JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:@"\
						  Konashi.signalStrengthRead();\
						  "];
		float progress = -1.0 * [v toDouble];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.dbBar.progress = progress / 100;

		NSLog(@"RSSI: %f", progress);
	}];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"updateBatteryLevel" hendler:^(JSValue *value) {
		JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:@"\
					  Konashi.batteryLevelRead();\
					  "];
		float progress = [v toDouble];
		
		if(progress > 100.0){
			progress = 100.0;
		}
		
		self.batteryBar.progress = progress / 100;
	}];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"ready" hendler:^(JSValue *value) {
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
	}];
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.connected = function() {\
		Konashi.log('connected');\
	 };\
	 Konashi.ready = function() {\
		Konashi.log('ready');\
		KonashiBridgeHandler.ready();\
	 };\
	 Konashi.updateBatteryLevel = function() {\
		KonashiBridgeHandler.updateBatteryLevel();\
	 };\
	 Konashi.updateSignalStrength = function() {\
		KonashiBridgeHandler.updateRSSI();\
	 };"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 function find() {\
		if (Konashi.isConnected()) {\
			Konashi.log('disconnect');\
			Konashi.disconnect();\
			return true;\
		}\
		else {\
			Konashi.log('find');\
			Konashi.find();\
			return false;\
		}\
	 };"];
	JSValue *value = [KNSJavaScriptVirtualMachine callFunctionWithKey:@"find" args:nil];
	if ([value toBool] == NO) {
		[self.connectButton setTitle: @"konashi に接続する" forState:UIControlStateNormal];
	}
}

- (IBAction)disconnect:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.disconnect();\
	 "];
}

- (IBAction)reset:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.reset();\
	 "];
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
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.signalStrengthReadRequest();\
	 "];
}

///////////////////////////////////////////////////
// バッテリー

- (IBAction)getBattery:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.batteryLevelReadRequest();\
	 "];
}

@end
