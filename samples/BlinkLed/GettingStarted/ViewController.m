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
    
    [Konashi initialize];
    
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] find];
}

- (void)ready
{
    // Drive LED
    [[Konashi sharedKonashi] setPWMMode:KonashiLED2 mode:KonashiPWMModeEnableLED];
    
    //Blink LED (interval: 0.5s)
    [[Konashi sharedKonashi] setPWMPeriod:KonashiLED2 period:1000000];   // 1.0s
    [[Konashi sharedKonashi] setPWMDuty:KonashiLED2 duty:500000];       // 0.5s
    [[Konashi sharedKonashi] setPWMMode:KonashiLED2 mode:1];
}

@end
