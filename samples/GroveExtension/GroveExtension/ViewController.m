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
    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [Konashi addObserver:self selector:@selector(completeAnalogRead) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(readBrightness) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ready
{
    NSLog(@"Ready");
    [Konashi pwmMode:LED2 mode:KONASHI_PWM_ENABLE_LED_MODE];
}

- (void)completeAnalogRead
{
    int aioValue=[Konashi analogRead:AIO0];
    [Konashi pwmLedDrive:LED2 dutyRatio:aioValue/13];
    NSLog(@"Brightness:%d",aioValue);
}

- (void)readBrightness
{
    [Konashi readFromGroveAnalogPort:A0];
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}
@end
