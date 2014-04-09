//
//  ViewController.m
//  PioDrive
//
//  Created on 12/22/12.
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
    
	konashi1 = [Konashi createKonashiWithConnectedHandler:^(Konashi *k) {
	} disconnectedHandler:^(Konashi *k) {
		NSLog(@"DISCONNECTED:%@", k.peripheralName);
	} readyHandler:^(Konashi *k) {
		NSLog(@"READY peripheral name:%@", k.peripheralName);
		// Show buttons
		self.led3.hidden = NO;
		self.led4.hidden = NO;
		self.led5.hidden = NO;
		self.pioMessage.hidden = NO;
		
		[k pinMode:KonashiS1 mode:KonashiPinModeInput];
		[k pinMode:KonashiLED2 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED3 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED4 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED5 mode:KonashiPinModeOutput];
	}];
	konashi2 = [Konashi createKonashiWithConnectedHandler:^(Konashi *k) {
	} disconnectedHandler:^(Konashi *k) {
		NSLog(@"DISCONNECTED:%@", k.peripheralName);
	} readyHandler:^(Konashi *k) {
		NSLog(@"READY peripheral name:%@", k.peripheralName);
		// Show buttons
		self.led3.hidden = NO;
		self.led4.hidden = NO;
		self.led5.hidden = NO;
		self.pioMessage.hidden = NO;
		
		[k pinMode:KonashiS1 mode:KonashiPinModeInput];
		[k pinMode:KonashiLED2 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED3 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED4 mode:KonashiPinModeOutput];
		[k pinMode:KonashiLED5 mode:KonashiPinModeOutput];
	}];
	
	KonashiSignalStrengthDidUpdateHandler signal = ^(Konashi *k, int signalStrength) {
		NSLog(@"signal strength:%@(%d)", k.peripheralName, signalStrength);
	};
	KonashiDigitalPinDidChangeValueHandler input = ^(Konashi *k, KonashiDigitalIOPin pin, int value) {
		NSLog(@"input:%@(%d:%d)", k.peripheralName, pin, value);
		if (pin == KonashiS1 && value) {
			[k digitalWrite:KonashiLED2 value:KonashiLevelHigh];
		}
		else {
			[k digitalWrite:KonashiLED2 value:KonashiLevelLow];
		}
	};
	KonashiDigitalPinDidChangeValueHandler output = ^(Konashi *k, KonashiDigitalIOPin pin, int value) {
		NSLog(@"output:%@(%d:%d)", k.peripheralName, pin, value);
	};
	
	konashi1.signalStrengthDidUpdateHandler = signal;
	konashi1.digitalInputDidChangeValueHandler = input;
	konashi1.digitalOutputDidChangeValueHandler = output;
	
	konashi2.signalStrengthDidUpdateHandler = signal;
	konashi2.digitalInputDidChangeValueHandler = input;
	konashi2.digitalOutputDidChangeValueHandler = output;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    //[Konashi findWithName:@"konashi#4-0960"];
    [konashi1 find];
}

- (IBAction)find2:(id)sender
{
	[konashi2 find];
}

- (IBAction)disconnect:(id)sender {
    [konashi1 disconnect];
	[konashi2 disconnect];
}

- (IBAction)upLed3:(id)sender {
    [konashi1 digitalWrite:KonashiLED3 value:KonashiLevelLow];
	[konashi2 digitalWrite:KonashiLED3 value:KonashiLevelLow];
}

- (IBAction)downLed3:(id)sender {
    [konashi1 digitalWrite:KonashiLED3 value:KonashiLevelHigh];
	[konashi2 digitalWrite:KonashiLED3 value:KonashiLevelHigh];
}

- (IBAction)upLed4:(id)sender {
    [konashi1 digitalWrite:KonashiLED4 value:KonashiLevelLow];
	[konashi2 digitalWrite:KonashiLED4 value:KonashiLevelLow];
}

- (IBAction)downLed4:(id)sender {
    [konashi1 digitalWrite:KonashiLED4 value:KonashiLevelHigh];
	[konashi2 digitalWrite:KonashiLED4 value:KonashiLevelHigh];
}

- (IBAction)upLed5:(id)sender {
    [konashi1 digitalWrite:KonashiLED5 value:KonashiLevelLow];
	[konashi2 digitalWrite:KonashiLED5 value:KonashiLevelLow];
}

- (IBAction)downLed5:(id)sender {
    [konashi1 digitalWrite:KonashiLED5 value:KonashiLevelHigh];
	[konashi2 digitalWrite:KonashiLED5 value:KonashiLevelHigh];
}

/*- (void) cmPoweredOn
{
    [Konashi find];
}*/

/*- (void) peripheralNotFound
{
    NSLog(@"peripheralNotFound :-(");
}*/

- (void) disconnected
{
    NSLog(@"DISCONNECTED");
}

@end
