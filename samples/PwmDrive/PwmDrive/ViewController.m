//
//  ViewController.m
//  PwmDrive
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
		// Drive LED
		[Konashi pwmMode:KonashiLED2 mode:KonashiPWMModeEnableLED];
		[Konashi pwmLedDrive:KonashiLED2 dutyRatio:50.0];
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

- (IBAction)changeLedBrightness20:(id)sender {
    [Konashi pwmLedDrive:KonashiLED2 dutyRatio:20.0];
}

- (IBAction)changeLedBrightness50:(id)sender {
    [Konashi pwmLedDrive:KonashiLED2 dutyRatio:50.0];
}

- (IBAction)changeLedBrightness80:(id)sender {
    [Konashi pwmLedDrive:KonashiLED2 dutyRatio:80.0];
}

- (IBAction)changeLedBrightnessBar:(id)sender {
    NSLog(@"Brightness: %f", self.brightnessSlider.value);
    
    [Konashi pwmLedDrive:KonashiLED2 dutyRatio:self.brightnessSlider.value];
}

@end
