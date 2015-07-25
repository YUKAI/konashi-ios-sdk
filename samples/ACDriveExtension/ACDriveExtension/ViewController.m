//
//  ViewController.m
//  ACDriveExtension
//
//  Created by yukai on 2013/10/07.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi+ACDrive.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize brightnessSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[Konashi shared] setReadyHandler:^{
	    NSLog(@"Ready");
	    [Konashi initACDrive:KONASHI_AC_MODE_PWM freq:KONASHI_AC_FREQ_50HZ];
    }];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(refreshDuty) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDuty
{
    int duty;
    duty = [brightnessSlider value];
    NSLog(@"Duty: %d",duty);
    [Konashi updateACDriveDuty:duty];
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

@end