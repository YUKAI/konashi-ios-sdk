//
//  ViewController.m
//  GroveExtension
//
//  Created by yukai on 2013/10/07.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi+Grove.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"Ready");
		[Konashi pwmMode:KonashiLED2 mode:KonashiPWMModeEnableLED];
	}];
	[[Konashi shared] setAnalogPinDidChangeValueHandler:^(KonashiAnalogIOPin pin, int value) {
		int aioValue = [Konashi analogRead:KonashiAnalogIO0];
		[Konashi pwmLedDrive:KonashiLED2 dutyRatio:aioValue/13];
		NSLog(@"Brightness:%d",aioValue);
	}];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(readBrightness) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readBrightness
{
    [Konashi readGroveAnalogPort:KonashiAnalogIO0];
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}
@end
