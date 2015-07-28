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
	[[Konashi shared] setDisconnectedHandler:^{
		NSLog(@"DISCONNECTED");
	}];
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"READY peripheral name:%@", [Konashi peripheralName]);
		
		// Show buttons
		self.led3.hidden = NO;
		self.led4.hidden = NO;
		self.led5.hidden = NO;
		self.pioMessage.hidden = NO;
		
		[Konashi pinMode:KonashiS1 mode:KonashiPinModeInput];
		[Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
		[Konashi pinMode:KonashiLED3 mode:KonashiPinModeOutput];
		[Konashi pinMode:KonashiLED4 mode:KonashiPinModeOutput];
		[Konashi pinMode:KonashiLED5 mode:KonashiPinModeOutput];
	}];
	[[Konashi shared] setDigitalInputDidChangeValueHandler:^(KonashiDigitalIOPin pin, int value) {
		NSLog(@"UPDATE_PIO_INPUT");
		
		if([Konashi digitalRead:KonashiS1]){
			[Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
		} else {
			[Konashi digitalWrite:KonashiLED2 value:KonashiLevelLow];
		}
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

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

- (IBAction)upLed3:(id)sender {
    [Konashi digitalWrite:KonashiLED3 value:KonashiLevelLow];
}

- (IBAction)downLed3:(id)sender {
    [Konashi digitalWrite:KonashiLED3 value:KonashiLevelHigh];
}

- (IBAction)upLed4:(id)sender {
    [Konashi digitalWrite:KonashiLED4 value:KonashiLevelLow];
}

- (IBAction)downLed4:(id)sender {
    [Konashi digitalWrite:KonashiLED4 value:KonashiLevelHigh];
}

- (IBAction)upLed5:(id)sender {
    [Konashi digitalWrite:KonashiLED5 value:KonashiLevelLow];
}

- (IBAction)downLed5:(id)sender {
    [Konashi digitalWrite:KonashiLED5 value:KonashiLevelHigh];
}

- (void) updatePioInput
{
    NSLog(@"UPDATE_PIO_INPUT");
    
    if([Konashi digitalRead:KonashiS1]){
        [Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
    } else {
        [Konashi digitalWrite:KonashiLED2 value:KonashiLevelLow];
    }
}

@end
