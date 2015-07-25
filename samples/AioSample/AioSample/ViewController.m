//
//  ViewController.m
//  AioSample
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
		
		self.statusMessage.hidden = FALSE;
	}];
	[[Konashi shared] setAnalogPinDidChangeValueHandler:^(KonashiAnalogIOPin pin, int value) {
		NSLog(@"READ_AIO0: %d", [Konashi analogRead:KonashiAnalogIO0]);
		self.adcValue.text = [NSString stringWithFormat:@"%.3f", (float)[Konashi analogRead:KonashiAnalogIO0]/1000];
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

- (IBAction)setVoltage1000:(id)sender {
    [Konashi analogWrite:KonashiAnalogIO0 milliVolt:1000];
}

- (IBAction)requestReadAio0:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO0];
}

@end
