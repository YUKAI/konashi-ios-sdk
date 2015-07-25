//
//  ViewController.m
//  GettingStarted
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
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
	
    [[Konashi shared] setReadyHandler:^{
	    // Drive LED
	    [Konashi pwmMode:KonashiLED2 mode:KonashiPWMModeEnableLED];
	    
	    //Blink LED (interval: 0.5s)
	    [Konashi pwmPeriod:KonashiLED2 period:1000000];   // 1.0s
	    [Konashi pwmDuty:KonashiLED2 duty:500000];       // 0.5s
	    [Konashi pwmMode:KonashiLED2 mode:KonashiPWMModeEnable];
	    
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

@end
