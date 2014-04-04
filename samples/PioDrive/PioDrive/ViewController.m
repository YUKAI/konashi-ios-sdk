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
    
	[Konashi initWithConnectedHandler:^(Konashi *konashi) {
		
	} disconnectedHandler:^(Konashi *konashi) {
		[self disconnect:nil];
	} readyHandler:^(Konashi *konashi) {
		NSLog(@"READY peripheral name:%@", [Konashi peripheralName]);
		
		// Show buttons
		self.led3.hidden = NO;
		self.led4.hidden = NO;
		self.led5.hidden = NO;
		self.pioMessage.hidden = NO;
		
		[Konashi pinMode:S1 mode:KonashiPinModeInput];
		[Konashi pinMode:LED2 mode:KonashiPinModeOutput];
		[Konashi pinMode:LED3 mode:KonashiPinModeOutput];
		[Konashi pinMode:LED4 mode:KonashiPinModeOutput];
		[Konashi pinMode:LED5 mode:KonashiPinModeOutput];
	}];
    //[Konashi addObserver:self selector:@selector(cmPoweredOn) name:KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON];
    //[Konashi addObserver:self selector:@selector(peripheralNotFound) name:KONASHI_EVENT_PERIPHERAL_NOT_FOUND];
	[Konashi shared].digitalInputDidChangeValueHandler = ^(Konashi *konashi, KonashiDigitalIOPin pin, int value) {
		NSLog(@"input  %d:%d", pin, value);
		if (pin == S1 && value) {
			[Konashi digitalWrite:LED2 value:KonashiLevelHigh];
		}
		else {
			[Konashi digitalWrite:LED2 value:KonashiLevelLow];
		}
	};
	[Konashi shared].digitalOutputDidChangeValueHandler = ^(Konashi *konashi, KonashiDigitalIOPin pin, int value) {
		NSLog(@"output %d:%d", pin, value);
	};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    //[Konashi findWithName:@"konashi#4-0960"];
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

- (IBAction)upLed3:(id)sender {
    [Konashi digitalWrite:LED3 value:KonashiLevelLow];
}

- (IBAction)downLed3:(id)sender {
    [Konashi digitalWrite:LED3 value:KonashiLevelHigh];
}

- (IBAction)upLed4:(id)sender {
    [Konashi digitalWrite:LED4 value:KonashiLevelLow];
}

- (IBAction)downLed4:(id)sender {
    [Konashi digitalWrite:LED4 value:KonashiLevelHigh];
}

- (IBAction)upLed5:(id)sender {
    [Konashi digitalWrite:LED5 value:KonashiLevelLow];
}

- (IBAction)downLed5:(id)sender {
    [Konashi digitalWrite:LED5 value:KonashiLevelHigh];
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
